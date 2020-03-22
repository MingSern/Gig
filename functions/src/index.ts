import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
// const fcm = admin.messaging();

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


export const jobRecommendation = functions.firestore
    .document("accounts/{accountId}")
    .onUpdate(async event => {
        const beforeData = event.before.data();
        const afterData = event.after.data();

        if (beforeData === undefined) return;
        if (afterData === undefined) return;
        if (beforeData.preferedCategories === afterData.preferedCategories) return;

        const querySnapshot = await db
            .collection("jobs")
            .get();

        var jobs: any[] = [];

        querySnapshot.forEach(function (snapshot) {

            if (afterData === undefined) return;

            const document = snapshot.data();
            const wages = parseFloat(document.wages);
            const range = afterData.preferedWages.split("-");
            const start = parseFloat(range[0]);
            const end = parseFloat(range[1]);
            const within = wages >= start && wages <= end;
            const match = afterData.preferedCategories.includes(document.category);

            if (within && match) {
                jobs.push(document.key);
            }

        });

        console.log(jobs);
        console.log("------------- SAVE PREFERED JOBS DONE -------------");

        return db.collection("recommendedJobs")
            .doc(afterData.uid)
            .set({ preferedJobs: jobs });
    });