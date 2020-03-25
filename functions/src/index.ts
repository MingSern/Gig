import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
// const fcm = admin.messaging();

export const recommendedJobs = functions.firestore
    .document("jobs/{jobId}")
    .onCreate(async snapshot => {

        const stringSimilarity = require('string-similarity');
        const jaccard = require('jaccard-array');

        const queryUsers = db
            .collection("accounts")
            .where("userType", "==", "UserType.jobseeker")
            .get();

        const queryJobs = db
            .collection("jobs")
            .get();

        const [users, jobs] = await Promise.all([queryUsers, queryJobs]);

        const isSimilarAge = (user: any, otherUser: any) => {

            const userAge = Number(user.age);
            const otherUserAge = Number(otherUser.age);
            const ageDifference = userAge - otherUserAge;

            // Is it within 2 years difference?
            return ageDifference >= -2 && ageDifference <= 2;

        }

        const jaccardSimilarity = (user: any, otherUser: any) => {

            const userCategories = user.data().preferredCategories;
            const otherUserCategories = otherUser.data().preferredCategories;
            const similarity = jaccard(userCategories, otherUserCategories);

            return similarity;

        }

        users.forEach(function (user) {

            const pendings = user.data().pendings;
            const shortlists = user.data().shortlists;
            const appliedJobs = [...pendings, ...shortlists];
            const appliedJobsKey = appliedJobs.map((job) => job.key);

            var preferredJobs: any[] = [];

            jobs.forEach(function (job) {

                if (user.data().preferredCategories.includes(job.data().category)) {

                    if (!appliedJobsKey.includes(job.data().key)) {

                        preferredJobs.push(job.data());

                    }

                }

            });

            var recommendedJobs: any[] = [];
            const isNewUser = appliedJobs.length < 1;

            if (isNewUser) {

                // Demographic filtering
                const mappedOtherUsers = users.docs.map(function (otherUser) {

                    const pendings = otherUser.data().pendings;
                    const shortlists = otherUser.data().shortlists;

                    return {
                        uid: otherUser.data().uid,
                        age: otherUser.data().age,
                        gender: otherUser.data().gender,
                        appliedJobs: [...pendings, ...shortlists],
                        similarity: jaccardSimilarity(user, otherUser),
                    };

                });

                const otherUsers = mappedOtherUsers.filter(function (otherUser) {

                    const notUser = otherUser.uid !== user.data().uid;
                    const similarAge = isSimilarAge(user.data(), otherUser);
                    const isSameGender = user.data().gender == otherUser.gender;
                    const similarJobCategories = otherUser.similarity != 0;

                    return notUser && similarAge && isSameGender && similarJobCategories;

                });

                otherUsers.sort((a, b) => b.similarity - a.similarity);

                otherUsers.forEach(function (otherUser) {

                    otherUser.appliedJobs.forEach(function (appliedJob: { key: any; }) {

                        if (!recommendedJobs.includes(appliedJob.key)) {

                            recommendedJobs.push({
                                id: appliedJob.key,
                                similarity: otherUser.similarity,
                            });

                        }

                    })

                });

                console.log("------------- Demographic Filtering Done -------------");

            } else {

                // Content-base filtering
                const workPositions = appliedJobs.map((job) => job.workPosition.toString());
                const descriptions = appliedJobs.map((job) => job.description.toString());

                preferredJobs.forEach(async function (prefferedJob) {

                    const s1 = stringSimilarity.findBestMatch(prefferedJob.workPosition, workPositions);
                    const s2 = stringSimilarity.findBestMatch(prefferedJob.description, descriptions);

                    // Compute similarity
                    const [workPositionSimilarity, descriptionSimilarity] = await Promise.all([s1, s2]);

                    // Map the ratings into an array of rating
                    const mappedS1 = workPositionSimilarity.ratings.map((result: { rating: any; }) => result.rating);
                    const mappedS2 = descriptionSimilarity.ratings.map((result: { rating: any; }) => result.rating);

                    // Get the total rating
                    const sumWorkPositionRating = mappedS1.reduce(function (sum: any, result: any) {
                        return sum + result;
                    });

                    const sumDescriptionRating = mappedS2.reduce(function (sum: any, result: any) {
                        return sum + result;
                    });

                    // Calculate average rating
                    const averageWorkPositionRating = sumWorkPositionRating / workPositions.length;
                    const averageDesccriptionRating = sumDescriptionRating / descriptions.length;

                    // Let work position have a weight of 0.1
                    // While description have a weight of 0.9
                    const weightedAverage = (averageWorkPositionRating * 0.1) + (averageDesccriptionRating * 0.9);

                    if (weightedAverage > 0.5) {

                        recommendedJobs.push({
                            id: prefferedJob.key,
                            averageWorkPositionRating: averageWorkPositionRating,
                            averageDesccriptionRating: averageDesccriptionRating,
                            weightedAverage: weightedAverage,
                        });

                        recommendedJobs.sort((a: any, b: any) => b.weightedAverage - a.weightedAverage);

                    }

                });

                console.log("------------- Content-based Filtering Done -------------");

            }

            return db.collection("recommendedJobs")
                .doc(user.data().uid)
                .set({ recommendedJobs: recommendedJobs });

        })


        return;
    });

// export const chatNotification = functions.firestore
//     .document("chatRooms/{chatRoomsId}/messages/{messagesId}")
//     .onCreate(async snapshot => {
//         const message = snapshot.data();

//         if (message == undefined) {
//             console.log("------------- CHATROOM NOT EXIST -------------");
//             return;
//         }

//         const user = db
//             .collection("accounts")
//             .doc(message.uid)
//             .get();

//         const querySnapshot = db
//             .collection("accounts")
//             .doc(message.to)
//             .collection("token")
//             .get();

//         let [userResult, querySnapshotResult] = await Promise.all([user, querySnapshot]);

//         const tokens = querySnapshotResult.docs.map(snap => snap.id);

//         const userData = userResult.data();

//         if (userData == undefined) {
//             console.log("------------- USER NOT EXIST -------------");
//             return;
//         }

//         var titleMessage = " messaged you.";
//         var username = "Someone";

//         if (userData.businessName != null) {
//             username = userData.businessName;
//         } else if (userData.fullname != null) {
//             username = userData.fullname;
//         }

//         titleMessage = username + titleMessage;

//         const payload: admin.messaging.MessagingPayload = {
//             notification: {
//                 title: titleMessage,
//                 body: message.message,
//                 clickAction: "FLUTTER_NOTIFICATION_CLICK",
//                 sound: "default",
//             },
//         }

//         console.log("------------- TOKEN : " + tokens + " -------------");

//         return fcm.sendToDevice(tokens, payload);
//     });


// export const preferredJobs = functions.firestore
//     .document("accounts/{accountId}")
//     .onUpdate(async event => {
//         const beforeData = event.before.data();
//         const afterData = event.after.data();

//         if (beforeData === undefined) return;
//         if (afterData === undefined) return;
//         if (beforeData.preferredCategories === afterData.preferredCategories) return;

//         const querySnapshot = await db
//             .collection("jobs")
//             .get();

//         var jobs: any[] = [];

//         querySnapshot.forEach(function (snapshot) {

//             if (afterData === undefined) return;

//             const document = snapshot.data();
//             const wages = parseFloat(document.wages);
//             const range = afterData.preferredWages.split("-");
//             const start = parseFloat(range[0]);
//             const end = parseFloat(range[1]);
//             const within = wages >= start && wages <= end;
//             const match = afterData.preferredCategories.includes(document.category);

//             if (within && match) {
//                 jobs.push(document.key);
//             }

//         });

//         console.log("------------- Save Preffered Jobs Done -------------");

//         return db.collection("preferredJobs")
//             .doc(afterData.uid)
//             .set({ preferredJobs: jobs });
//     });


