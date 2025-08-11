import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

// 새 메시지 생성 시 수신자에게 푸시 발송
export const sendPushOnNewMessage = functions.firestore
  .document('threads/{threadId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const threadId = context.params.threadId;
    const senderId = data.senderId as string;

    const thread = await admin.firestore().collection('threads').doc(threadId).get();
    const members = (thread.data()?.members as string[]) ?? [];
    const recipients = members.filter((m) => m !== senderId);

    const tokensSnap = await admin
      .firestore()
      .collection('users')
      .where(admin.firestore.FieldPath.documentId(), 'in', recipients)
      .get();
    const tokens = tokensSnap.docs.map((d) => d.data().token).filter((t) => t);

    if (tokens.length === 0) return;

    await admin.messaging().sendMulticast({
      tokens: tokens as string[],
      notification: {
        title: '새 메시지',
        body: data.body as string,
      },
    });
  });

// FCM 토큰 등록
export const registerToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', '로그인이 필요합니다');
  }
  await admin
    .firestore()
    .collection('users')
    .doc(context.auth.uid)
    .set({ token: data.token }, { merge: true });
});
