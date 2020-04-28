import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const scheduleRecommendation = functions.pubsub
    .schedule("0 * * * *").onRun(async context => {

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

        users.forEach(async function (user) {

            const pendings = user.data().pendings;
            const shortlists = user.data().shortlists;
            const appliedJobs = [...pendings, ...shortlists];
            const otherUsers = users.docs.filter((otherUser) => otherUser.data().uid !== user.data().uid);

            var recommendedJobs: any[] = [];
            var collaborativeRecommendations: any[] = [];
            var contentBasedRecommendations: any[] = [];

            // Collaborative filtering
            const userAppliedJobs = appliedJobs;

            // do not do collaborative recommendation for new users
            if (userAppliedJobs.length == 0) return;

            const mappedOtherUsers = otherUsers.map(function (otherUser) {

                const pendings = otherUser.data().pendings;
                const shortlists = otherUser.data().shortlists;
                const otherUserAppliedJobs = [...pendings, ...shortlists];
                const differences = otherUserAppliedJobs.filter((job) => !userAppliedJobs.includes(job));

                return {
                    uid: otherUser.data().uid,
                    differences: differences,
                    appliedJobs: otherUserAppliedJobs,
                    similarity: jaccard(userAppliedJobs, otherUserAppliedJobs),
                };

            });

            mappedOtherUsers.sort((a, b) => b.similarity - a.similarity);

            mappedOtherUsers.forEach(function (otherUser) {

                otherUser.differences.forEach(function (difference) {

                    if (otherUser.similarity > 0) {

                        const recommendedJob = {
                            id: difference.key,
                            uid: otherUser.uid,
                            similarity: otherUser.similarity,
                            appliedJobs: otherUser.appliedJobs.map((job) => job.key),
                        };

                        if (!collaborativeRecommendations.includes(recommendedJob)) {
                            collaborativeRecommendations.push(recommendedJob);
                        }

                    }

                });

            });

            console.log("------------- Collaborative Filtering Done -------------");

            // Content-base filtering
            const appliedJobsKey = appliedJobs.map((job) => job.key);
            var preferredJobs: any[] = [];

            jobs.forEach(function (job) {

                if (user.data().preferredCategories.includes(job.data().category)) {

                    if (!appliedJobsKey.includes(job.data().key)) {

                        preferredJobs.push(job.data());

                    }

                }

            });

            const workPositions = appliedJobs.map((job) => job.workPosition.toString());
            const descriptions = appliedJobs.map((job) => job.description.toString());

            for (let index = 0; index < preferredJobs.length; index++) {

                const s1 = stringSimilarity.findBestMatch(preferredJobs[index].workPosition, workPositions);
                const s2 = stringSimilarity.findBestMatch(preferredJobs[index].description, descriptions);

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

                // Let work position have a weight of 0.2
                // While description have a weight of 0.8
                const weightedAverage = (averageWorkPositionRating * 0.2) + (averageDesccriptionRating * 0.8);

                if (weightedAverage > 0.5) {

                    const recommendedJob = {
                        id: preferredJobs[index].key,
                        averageWorkPositionRating: averageWorkPositionRating,
                        averageDesccriptionRating: averageDesccriptionRating,
                        similarity: weightedAverage,
                    };

                    if (!contentBasedRecommendations.includes(recommendedJob)) {
                        contentBasedRecommendations.push(recommendedJob);
                    }

                }

            }

            contentBasedRecommendations.sort((a: any, b: any) => b.similarity - a.similarity);
            collaborativeRecommendations.sort((a: any, b: any) => b.similarity - a.similarity);
            const array_one = contentBasedRecommendations.slice(0, 15);
            const array_two = collaborativeRecommendations.slice(0, 15);
            recommendedJobs = [...array_one, ...array_two];

            console.log("------------- Content-based Filtering Done -------------");

            return db.collection("recommendedJobs")
                .doc(user.data().uid)
                .set({ recommendedJobs: recommendedJobs });

        })

        return;

    });



// export const demographicRecommendations = functions.firestore
//     .document("accounts/{accountId}")
//     .onUpdate(async snapshot => {

//         const beforeData = snapshot.before.data();
//         const afterData = snapshot.after.data();

//         if (beforeData == undefined) return;
//         if (afterData == undefined) return;

//         const beforeNotExist = beforeData.preferredCategories == null || beforeData.preferredCategories.length < 1;
//         const currentlyExist = afterData.preferredCategories.length > 0;
//         const isNewUser = currentlyExist && beforeNotExist;

//         // Demographic filtering
//         if (isNewUser) {

//             var demographicRecommendations: any[] = [];

//             const jaccard = require('jaccard-array');

//             const query1 = await db
//                 .collection("accounts")
//                 .where("userType", "==", "UserType.jobseeker")
//                 .get();

//             const query2 = await db
//                 .collection("jobs")
//                 .get();

//             const [users, jobs] = await Promise.all([query1, query2]);

//             const user = afterData;

//             const otherUsers = users.docs.filter((otherUser) => otherUser.data().uid !== user.uid);

//             const isSimilarAge = (otherUser: any) => {

//                 const userAge = Number(user.age);
//                 const otherUserAge = Number(otherUser.age);
//                 const ageDifference = userAge - otherUserAge;

//                 return ageDifference >= -3 && ageDifference <= 3;

//             }

//             const jaccardSimilarity = (otherUser: any) => {

//                 const userCategories = user.preferredCategories;
//                 const otherUserCategories = otherUser.data().preferredCategories;
//                 const similarity = jaccard(userCategories, otherUserCategories);

//                 return similarity;

//             }

//             const checkGroupAge = (userAge: any, jobPreferredAge: any) => {

//                 const age = parseInt(userAge);

//                 switch (jobPreferredAge) {
//                     case "18-20":
//                         return age >= 18 && age <= 20;

//                     case "21-30":
//                         return age >= 21 && age <= 30;

//                     case "31-40":
//                         return age >= 31 && age <= 40;

//                     default:
//                         return true;
//                 }

//             }

//             const uniqueArrayOfObject = (array: any[], keyToBeUnique: string | number) => {

//                 return array.filter((x: any, xi: any) => !array.slice(xi + 1).some((y: { [x: string]: any; }) => y[keyToBeUnique] === x[keyToBeUnique]));

//             }

//             const mappedUsers = otherUsers.map(function (otherUser) {

//                 const pendings = otherUser.data().pendings;
//                 const shortlists = otherUser.data().shortlists;

//                 return {
//                     uid: otherUser.data().uid,
//                     age: otherUser.data().age,
//                     gender: otherUser.data().gender,
//                     appliedJobs: [...pendings, ...shortlists],
//                     preferredCategories: otherUser.data().preferredCategories,
//                     similarity: jaccardSimilarity(otherUser),
//                 };

//             });

//             const filterredUsers = mappedUsers.filter(function (otherUser) {

//                 const similarAge = isSimilarAge(otherUser);
//                 const isSameGender = user.gender == otherUser.gender;
//                 const similarJobCategories = otherUser.similarity > 0;

//                 return similarAge && isSameGender && similarJobCategories;

//             });

//             filterredUsers.forEach(function (otherUser) {

//                 otherUser.appliedJobs.forEach(function (appliedJob) {

//                     demographicRecommendations.push({
//                         id: appliedJob.key,
//                         uid: otherUser.uid,
//                         preferredCategories: otherUser.preferredCategories,
//                         similarity: otherUser.similarity,
//                     });

//                 });

//             })

//             if (demographicRecommendations.length < 1) {

//                 jobs.forEach(function (job) {

//                     const document = job.data();
//                     const wages = parseFloat(document.wages);
//                     const range = user.preferredWages.split("-");
//                     const start = parseFloat(range[0]);
//                     const end = parseFloat(range[1]);
//                     const within = wages >= start && wages <= end;
//                     const match = user.preferredCategories.includes(document.category);
//                     const sameGender = [user.gender, "Any"].includes(document.gender);
//                     const withinGroupAge = checkGroupAge(user.age, document.age);

//                     if (within && match && sameGender && withinGroupAge) {
//                         demographicRecommendations.push({
//                             id: document.key
//                         });
//                     }

//                 });

//             }

//             const recommendedJobs = uniqueArrayOfObject(demographicRecommendations, "id");

//             recommendedJobs.sort((a, b) => b.similarity - a.similarity);

//             console.log("------------- Demographic Filtering Done -------------");

//             return db.collection("recommendedJobs")
//                 .doc(user.uid)
//                 .set({ recommendedJobs: recommendedJobs });

//         } else {

//             return;

//         }

//     });



export const jobRecommendations = functions.firestore
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

        users.forEach(async function (user) {

            const pendings = user.data().pendings;
            const shortlists = user.data().shortlists;
            const appliedJobs = [...pendings, ...shortlists];
            const otherUsers = users.docs.filter((otherUser) => otherUser.data().uid !== user.data().uid);

            var recommendedJobs: any[] = [];
            var collaborativeRecommendations: any[] = [];
            var contentBasedRecommendations: any[] = [];

            // Collaborative filtering
            const userAppliedJobs = appliedJobs;

            // do not do collaborative recommendation for new users
            if (userAppliedJobs.length == 0) return;

            const mappedOtherUsers = otherUsers.map(function (otherUser) {

                const pendings = otherUser.data().pendings;
                const shortlists = otherUser.data().shortlists;
                const otherUserAppliedJobs = [...pendings, ...shortlists];
                const differences = otherUserAppliedJobs.filter((job) => !userAppliedJobs.includes(job));

                return {
                    uid: otherUser.data().uid,
                    differences: differences,
                    appliedJobs: otherUserAppliedJobs,
                    similarity: jaccard(userAppliedJobs, otherUserAppliedJobs),
                };

            });

            mappedOtherUsers.sort((a, b) => b.similarity - a.similarity);

            mappedOtherUsers.forEach(function (otherUser) {

                otherUser.differences.forEach(function (difference) {

                    if (otherUser.similarity > 0) {

                        const recommendedJob = {
                            id: difference.key,
                            uid: otherUser.uid,
                            similarity: otherUser.similarity,
                            appliedJobs: otherUser.appliedJobs.map((job) => job.key),
                        };

                        if (!collaborativeRecommendations.includes(recommendedJob)) {
                            collaborativeRecommendations.push(recommendedJob);
                        }

                    }

                });

            });

            console.log("------------- Collaborative Filtering Done -------------");

            // Content-base filtering
            const appliedJobsKey = appliedJobs.map((job) => job.key);
            var preferredJobs: any[] = [];

            jobs.forEach(function (job) {

                if (user.data().preferredCategories.includes(job.data().category)) {

                    if (!appliedJobsKey.includes(job.data().key)) {

                        preferredJobs.push(job.data());

                    }

                }

            });

            const workPositions = appliedJobs.map((job) => job.workPosition.toString());
            const descriptions = appliedJobs.map((job) => job.description.toString());

            for (let index = 0; index < preferredJobs.length; index++) {

                const s1 = stringSimilarity.findBestMatch(preferredJobs[index].workPosition, workPositions);
                const s2 = stringSimilarity.findBestMatch(preferredJobs[index].description, descriptions);

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

                // Let work position have a weight of 0.2
                // While description have a weight of 0.8
                const weightedAverage = (averageWorkPositionRating * 0.2) + (averageDesccriptionRating * 0.8);

                if (weightedAverage > 0.5) {

                    const recommendedJob = {
                        id: preferredJobs[index].key,
                        averageWorkPositionRating: averageWorkPositionRating,
                        averageDesccriptionRating: averageDesccriptionRating,
                        similarity: weightedAverage,
                    };

                    if (!contentBasedRecommendations.includes(recommendedJob)) {
                        contentBasedRecommendations.push(recommendedJob);
                    }

                }

            }

            contentBasedRecommendations.sort((a: any, b: any) => b.similarity - a.similarity);
            collaborativeRecommendations.sort((a: any, b: any) => b.similarity - a.similarity);
            const array_one = contentBasedRecommendations.slice(0, 15);
            const array_two = collaborativeRecommendations.slice(0, 15);
            recommendedJobs = [...array_one, ...array_two];

            console.log("------------- Content-based Filtering Done -------------");

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

//         if (message == undefined) return;

//         const query1 = db
//             .collection("accounts")
//             .doc(message.uid)
//             .get();

//         const query2 = db
//             .collection("accounts")
//             .doc(message.to)
//             .collection("token")
//             .get();

//         let [users, tokens] = await Promise.all([query1, query2]);

//         const token = tokens.docs.map(snap => snap.id);

//         const userData = users.data();

//         if (userData == undefined) return;

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

//         return fcm.sendToDevice(token, payload);
//     });

export const newApplicationNotification = functions.firestore
    .document("accounts/{accountId}")
    .onUpdate(async snapshot => {
        const before = snapshot.before.data();
        const after = snapshot.after.data();

        if (before == undefined || after == undefined) return null;

        const isEmployer = before.userType == "UserType.employer";
        const hasNewApplicant = before.pendings.length < after.pendings.length;
        const hasBeenShortlisted = before.shortlists.length < after.shortlists.length;
        const hasBeenRejected = before.pendings.length === after.pendings.length && before.pendings !== after.pendings;

        if (isEmployer && hasNewApplicant) {
            const afterString = after.pendings.map((pending: any) => JSON.stringify(pending));
            const beforeString = before.pendings.map((pending: any) => JSON.stringify(pending));

            const updatedApplicationStrings = afterString.filter(function (pending: any) {
                return !beforeString.includes(pending);
            });

            const updatedApplications = updatedApplicationStrings.map((pending: any) => JSON.parse(pending));

            console.log("updatedApplications", updatedApplications);

            const tokens = await db.collection("accounts").doc(before.uid).collection("token").get();
            const token = tokens.docs.map(snap => snap.id);

            updatedApplications.forEach(async function (application: any) {
                if (application.status == "JobStatus.pending") {
                    const message = application.name + " just applied one of your job.";
                    const payload: admin.messaging.MessagingPayload = {
                        notification: {
                            title: "You have a new applicant!",
                            body: message,
                            clickAction: "FLUTTER_NOTIFICATION_CLICK",
                            sound: "default",
                        },
                    }

                    return fcm.sendToDevice(token, payload);
                }

                return null;
            });
        }

        if (!isEmployer && hasBeenShortlisted) {
            const afterString = after.shortlists.map((shortlist: any) => JSON.stringify(shortlist));
            const beforeString = before.shortlists.map((shortlist: any) => JSON.stringify(shortlist));

            const updatedShortlistStrings = afterString.filter(function (shortlist: any) {
                return !beforeString.includes(shortlist);
            });

            const updatedShortlists = updatedShortlistStrings.map((shortlist: any) => JSON.parse(shortlist));

            console.log("updatedShortlists", updatedShortlists);

            const tokens = await db.collection("accounts").doc(before.uid).collection("token").get();
            const token = tokens.docs.map(snap => snap.id);

            updatedShortlists.forEach(async function (shortlist: any) {
                const message = shortlist.businessName + " has accepted your application.";
                const payload: admin.messaging.MessagingPayload = {
                    notification: {
                        title: "You have been shortlisted!",
                        body: message,
                        clickAction: "FLUTTER_NOTIFICATION_CLICK",
                        sound: "default",
                    },
                }

                return fcm.sendToDevice(token, payload);
            });
        }

        if (!isEmployer && hasBeenRejected) {
            const afterString = after.pendings.map((pending: any) => JSON.stringify(pending));
            const beforeString = before.pendings.map((pending: any) => JSON.stringify(pending));

            const updatedPendingStrings = afterString.filter(function (pending: any) {
                return !beforeString.includes(pending);
            });

            const updatedPendings = updatedPendingStrings.map((pending: any) => JSON.parse(pending));

            console.log("updatedPendings", updatedPendings);

            const tokens = await db.collection("accounts").doc(before.uid).collection("token").get();
            const token = tokens.docs.map(snap => snap.id);

            updatedPendings.forEach(async function (pending: any) {
                const message = pending.businessName + " has declined your application.";
                const payload: admin.messaging.MessagingPayload = {
                    notification: {
                        title: "Application declined.",
                        body: message,
                        clickAction: "FLUTTER_NOTIFICATION_CLICK",
                        sound: "default",
                    },
                }

                return fcm.sendToDevice(token, payload);
            });
        }

        return null;
    });