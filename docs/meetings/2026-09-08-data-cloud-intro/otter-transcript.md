# Otter transcript: Data Cloud Profile and Data Graph Issues

- Source: Otter.ai, folder "Sierra Circuits"
- Link: https://otter.ai/u/4Mlg-r2DQdvfLNraz57YbxSwrvw
- Recorded: 2026-09-08 06:00 PT (8:00 AM CDT), 22m 58s
- Speaker key (inferred from context): Speaker 2 = Veena, Speaker 3 = Bryant Daniels, Speaker 4 = Bikramaditya ("Vikram"). Speakers 1, 5, 6 are brief and unidentified.

## Otter AI summary

The team met to discuss technical issues regarding data visibility in the Profile Explorer and errors encountered when attempting to use the Data Graph.

Vikram presented the current status of the Unified Profile setup, noting that while data has been injected from Snowflake via Zero Copy and mapped from DLO to DMO, the information is not appearing correctly in the Profile Explorer. He reported a specific error when attempting to access or create a Data Graph, stating that he lacks access to all objects and fields. He also noted that even native Salesforce objects like Lead and Contact are not displaying their expected information within the explorer.

Vikram described a workaround for metadata changes in Snowflake where columns were failing to refresh. Instead of updating the existing DLO, he created duplicate columns with new names to allow for successful mapping. Bryant said this is a valid temporary workaround but recommended opening a case with Salesforce to investigate why the source changes are causing such frequent failures.

Bryant will perform a deep-dive analysis into the production environment once access is granted, investigating the relationship between accounts, contacts, and leads to ensure all data is consolidated into a single view within the Profile Explorer. Vikram will coordinate with his Salesforce team to provide temporary credentials for approximately two to three days.

## Action items (Otter)

- Bryant Daniels: Analyze the production Data Cloud configuration, investigate missing objects and data in the Profile Explorer and Data tab, identify best-practice gaps, and report findings without making changes before review.
- Bryant Daniels: Open a Salesforce case to determine why source metadata changes cause columns to become unavailable or fail to refresh.
- Bikramaditya: Provide temporary Salesforce access credentials to Bryant by email for two to three days.

## Transcript

- [0:00:55] Speaker 1: Hello.
- [0:00:58] Speaker 2: Hey, hi, Bryant.
- [0:01:01] Speaker 3: Hey, how's it going?
- [0:01:04] Speaker 2: Doing good. How are you?
- [0:01:05] Speaker 3: Ah, good, good.
- [0:01:10] Speaker 2: I think still people have to join from my end.
- [0:01:12] Speaker 3: Okay. Yeah. Is
- [0:01:17] Speaker 2: Louis joining, or you are the one? Uh, I'm
- [0:01:20] Speaker 3: not. Uh, I think Lewis might. I'm not positive. I know he gave me the access to the video, so I'm not sure if he's showing up or not. But I know we're doing just some introductions, and yeah, joining the team. So I'm here to help out, and I
- [0:01:41] Speaker 2: think
- [0:01:41] Speaker 3: access and a few other things.
- [0:01:44] Speaker 2: Okay. Let me remind them since the motion.
- [0:02:00] Speaker 3: All right.
- [0:02:02] Speaker 2: Just give me a second. I think by the time they join, I can give a summary. I think you might have gone through the email, right? So we created that profile, unified profile, and all those stuff. But we are not able to see, you know, all DLOS, DMOs, and all setup has been
- [0:02:36] Speaker 3: done. Okay.
- [0:02:36] Speaker 2: But due to that graphics one unified profile, where we can search and then can see the information of everything, right? That we are not able to see.
- [0:02:45] Speaker 3: Okay.
- [0:02:47] Speaker 2: I think is this action.
- [0:02:50] Speaker 3: I have a bit of the email thread, so I don't know if I have all of it. What I what was kind of summed up from like a Google AI or something like that was that. Let me see if I can find it.
- [0:03:04] Speaker 2: Sure. Can you just accept? I think people are waiting in the lobby. I think I don't see it. Do you see?
- [0:03:09] Speaker 3: I don't. I just see one guest. I see people. Just only you and me join.
- [0:03:17] Speaker 2: They're saying it's showing in the lobby. You have to accept that. I don't see it here anymore.
- [0:03:21] Speaker 3: That's what I'm saying. I don't see anyone in the lobby. I saw you in the lobby, and I I accept it. But I don't. The only guest I see in the yeah. Let me. I guess maybe I can log out. Or can you give them this meeting link? We can try that.
- [0:03:37] Speaker 2: No, they have this link. I mean, there is another link here somewhere. I can share it.
- [0:03:42] Speaker 3: I can give them this one to make sure they have the right one. I can give it to you because I don't have anything that's saying allow people to get in.
- [0:03:50] Speaker 2: Can we just ping here again? I can read.
- [0:03:54] Speaker 3: Yeah, here you go.
- [0:04:03] Speaker 2: Doing in the chat.
- [0:04:05] Speaker 3: There we go.
- [0:04:10] Speaker 2: Okay.
- [0:04:12] Speaker 3: Yeah, and I don't know if it's because Lewis had it and gave it over to me this morning. Yeah.
- [0:04:18] Speaker 2: Much enough.
- [0:04:33] Speaker 4: Hello. Hi everyone.
- [0:04:36] Speaker 3: Hey.
- [0:04:41] Speaker 2: Yeah, Vikram. So Vikram is the person who worked on this. I mean, Venki and these two people are the technical guys. I think they can show you and they can explain the summary and then where the problem is. Okay. Vikram, can you go ahead and share the screen and then explain to you know what you have done first and then in a quick way and then you can show him like you know what is the issue.
- [0:05:15] Speaker 4: It's not allowing me to share my screen, Bryant. Okay, now. Can you see my screen? Yes. Yeah right. So so I will start from the scratch where we started. Okay. Okay. So you see, right? Different source we have injected the data. Okay. Currently, I am not refreshing this data because as we were creating, right? So the first time only I refreshed the data. After that, I am not refreshing currently. Okay. Once everything done, then I thought of refreshing. That does not an issue, right? Creating the next steps. Okay. Okay. After that, I I have done everything the mapping with the DLO to DMO. Okay, like it's different source table. Okay. With our native DMOs, or if it is not there, we have created a custom one. If you see, I have opened the custom one, and that I create a relationship between those two tables as well. Okay. Okay. After creation of the data stream, okay, we have checked in the data explorer. We see its stable data is properly populated there. Okay, in Data Explorer. Okay, then we created some conditions rules identity regulation. Okay, if you see, like to check, we have only created for the DMO objects, okay. Few DMO objects I created, okay.
- [0:08:25] Speaker 3: All right.
- [0:08:25] Speaker 4: Where where I just do the fuzzy match and all. Ah, name and email and phone and emails, okay. Those are the fuzzy match I am doing currently, okay. Then we have some few calculations which we created. Okay, so you can see right for the score, why the intent score KPIs we created. Tool users already insert calculations. Okay, these are the calculation we created. Okay, so after that, I just wanted to like see the information in the profile explorer. Okay, so we have created a CMR ID, unified ID. Okay, so when we select and go to the unified individual ID, okay, say any first name wise, I'm searching. So currently, if you see the information, what I see it here, it's a limited information. Okay, I don't see each table, whatever the source table I have injected. Those all information I don't see in the profile explorer. Okay, I was checking with the support team, so they told me something need to be created in data graph. Okay, so while I exploring the data graph, okay, I will go there. Meanwhile, it's loading. Yeah. So in the data model, when I try to add my Salesforce objects, like suppose say lead. I don't see the lead one. Okay, then see contacts. So ever you see the message, right? You can't view or create data graph because you don't have access to all objects and fields. Contact your Salesforce admin. So whenever I search any objects, I get this. This is an error. Okay.
- [0:11:32] Speaker 3: Okay. Okay. All right.
- [0:11:36] Speaker 4: And come to okay. Let's pause here and go to the profile explorer and see. So activities I don't see calculated insight I don't see. Okay, how exactly we wanted to see the profile explorer in our database? The different database we have company information, contact information, right? Lead information, then engage engagement, market activity, outreach activity. So we want in the profile explore everything should be in one piece. Okay, based on okay, this is the account ID and this is the company. Then under that we have this many contacts and leads. Okay, that's the flow we were we were looking to achieve in the profile explorer.
- [0:12:19] Speaker 3: Um, one question I did have: Can you go back to your data streams?
- [0:12:27] Speaker 4: Yeah.
- [0:12:28] Speaker 3: Can you do all of them instead of the recently viewed?
- [0:12:33] Speaker 4: Sorry, your voice is slow. Can you repeat
- [0:12:35] Speaker 3: all of them instead of the recently viewed in the pick list?
- [0:12:39] Speaker 4: All of them.
- [0:12:40] Speaker 3: Yeah. Do you right up? Yep. Up top, right there, where it says recently viewed.
- [0:12:46] Speaker 4: Uh huh. Okay. Okay.
- [0:12:48] Speaker 3: Yeah. Yeah.
- [0:12:49] Speaker 4: All data streams.
- [0:12:50] Speaker 3: So I was just looking. So you're bringing in Snowflake, right? As well.
- [0:12:57] Speaker 4: Yes.
- [0:12:58] Speaker 3: Is that information needing to come in as how is it set up currently? Is it or does that need to come in? You know what I mean. Like I notice that because the accounts and contacts, I understand that when the leads as well. But if there's any other information that needs to be on that profile page, like engagement activity, are you grabbing it from here, or are we doing it just from like the engagements that's coming in from the lead activity?
- [0:13:28] Speaker 4: So the source, whatever you see, different source that is actually Snowflake is the one source where we create a different table. So engagement activity contacts, okay, all those different activities, and using the zero copy, we injected the data. And while injecting wherever the engagement data we choose as the engagement, wherever activity data we choose the activity, then we injected.
- [0:13:54] Speaker 3: So on that Snowflake, on those when when you have accounts and contacts, is there an identifier from Snowflake that we're able to use as a unique identifier to establish.
- [0:14:06] Speaker 4: Yes.
- [0:14:07] Speaker 3: Can you show it to? Can you tell me what it is, or show it to me?
- [0:14:29] Speaker 4: So here you see right the lead ID.
- [0:14:32] Speaker 3: ID okay.
- [0:14:33] Speaker 4: Lead ID we have the primary key like which is in the our Snowflake table. Okay, MID also. okay, and also what we added in Salesforce, we have an ID, right? That ID we were keeping in each table in the Snowflake as well, so that also be injected.
- [0:14:56] Speaker 3: Okay, okay, okay, all right, and for the other streams,
- [0:15:05] Speaker 1: do
- [0:15:06] Speaker 3: have either the lead ID, MID, or
- [0:15:09] Speaker 1: yeah.
- [0:15:10] Speaker 5: Okay.
- [0:15:11] Speaker 4: Yeah. So if every table have the lead ID, sorry, lead ID or email ID or member ID. This free. Yeah.
- [0:15:21] Speaker 3: Yeah. Okay. Okay. Um. So you're having a problem seeing the objects and that and the profile. Okay. Um. Sorry, I have a little sheet of questions. You actually already answered most of them. Um. Okay. What about what? What else? As far as like calculated insights, are you all using those or segments that need to be looked at? It sounds like just the objects and the data graph that you're having a problem with currently, and leveraging that. Are you trying to use any related lists or anything on some of the accounts and contacts in the CRM, or that that'll probably be solved after we get this relationship. Actually,
- [0:16:09] Speaker 4: yes, yes. So mostly, if you see the data in the day profile explorer, okay, we have Salesforce lead and contact object, right? So that also we have relation, right? But I don't see those information as well. So let's skip about now for the injected data. But the account lead and contact object information also in the profile explorer, we not able to see.
- [0:16:41] Speaker 3: Okay, all right. So it looks like you all are also working out of prod production.
- [0:16:49] Speaker 4: Yeah.
- [0:16:50] Speaker 3: Okay. So I guess the next steps. I would just need access to get in there, and then just do a little analysis. I won't be changing anything until I show you all what's going on there, and then we can kind of go from there if that's okay.
- [0:17:11] Speaker 4: Yes. So when when you ask for an user, so like what we do normally when we connect to support, we give access for one two days right from our user only. So likewise, you were looking or in a user name password directly you wanted to access.
- [0:17:28] Speaker 3: So I'm not with like Salesforce support. I'm with Kicksaw. However, they implemented it before. I don't know if they open up the support system. I know what you mean by opening up for support with Salesforce, but I haven't done it with just
- [0:17:45] Speaker 1: us.
- [0:17:46] Speaker 3: And I only need like two days, two or three days.
- [0:17:49] Speaker 4: Okay, okay. So let let me my Salesforce team. I ask to share with you the informations. Okay.
- [0:17:56] Speaker 3: Okay.
- [0:17:57] Speaker 4: But you understand where we have the pain points right in the profile explorer in the data tab. Those are the two.
- [0:18:06] Speaker 3: Yeah.
- [0:18:07] Speaker 4: Also, I have another question. As already I have googled it and find out the answers, but I just trying to understand. Say, when we inject the data as a zero copy, okay, in the source table, if anything changes, I see there is an issue on the tables. Okay, it is a failing to rephrase.
- [0:18:29] Speaker 3: Yeah, generally that happens when a metadata change happens from the source. So if it's like maybe going from a text to a number could change it, or even add in a few. What I've known in my implementations is that data cloud can be very finicky. So a lot of times, if if something's changed in the source, you have to make sure that it's updated in Salesforce because a lot of those moving parts are connected. Is that happening Right now,
- [0:19:01] Speaker 4: yes, I have handled it in a different way, but I just wanted to show.
- [0:19:09] Speaker 3: Did you have to delete everything and then put
- [0:19:12] Speaker 4: it? No, no, no. So if you see these columns, right, habitant quote count, 10 femmes order exists. These are these are showing it's not exist actually, but before it is exist and as it is took as a photocopy, I am able to see these columns. But what I did, it was allowing me to add new columns. Okay, so these columns I named it different and added it and mapped it perfectly, and I'm just keeping those columns here, whatever already there, which is showing like not exist.
- [0:19:48] Speaker 3: Yeah, I see what you're.
- [0:19:50] Speaker 4: Is that a good practice to do, or there is any other way?
- [0:19:55] Speaker 3: Um, if you are you looking just to get rid of them entirely, or just trying to like see if the order exists or has completed, or are you asking if it's okay to leave them there without them being mapped?
- [0:20:14] Speaker 4: No. What I'm saying. So suppose say this column, right? Fence order exist. It says it's not exist column, right? Due to the changes happened in the source table.
- [0:20:28] Speaker 3: What you're asking? Okay.
- [0:20:30] Speaker 4: So what I did instead, this column is not refreshing and is not allowing me. So I created a duplicate column called fames order exist. Okay, that I pushed and added as a new column because it is allowing me to add new columns. But if there isn't changes, it was not updating. So I mapped that copied column, duplicate one, and I left as it is the existing column.
- [0:21:00] Speaker 3: Gotcha. Yeah, that is one way to work around that. The other way is you could probably go to the DLO and update, just update the API names. But in order to do that, you'd have to tap a lot of stuff. So
- [0:21:15] Speaker 4: yes,
- [0:21:17] Speaker 3: yes. Yeah. Right. So like that's that's why I said that's a good workaround for that. But it shouldn't be happening that often. We could probably open up a case with Salesforce to understand why it's it's it's it's like a area now because you don't have to do that all the time whenever it updates like that. So I would open case to see why.
- [0:21:39] Speaker 4: Thank you. Oh. Yeah, that that's from my end. We'll save you after this call. The is your details, okay? And if still have any questions for me, you can drop me in an email. I will reply you.
- [0:21:55] Speaker 3: Okay.
- [0:21:57] Speaker 4: Okay. Okay.
- [0:22:00] Speaker 3: Sounds good. Um, do you have any questions for me?
- [0:22:03] Speaker 4: No, from my end, I'm good.
- [0:22:07] Speaker 3: All right.
- [0:22:12] Speaker 6: Cool.
- [0:22:12] Speaker 1: Thanks. Yeah.
- [0:22:13] Speaker 3: So yeah, once I get access, I'll start digging in, getting these profiles connected and stuff. So I'll look in to see what's going on and get back with you.
- [0:22:25] Speaker 4: Okay. Okay. And please let us know if there is a best practice which we were missing. Okay.
- [0:22:31] Speaker 3: Yeah, definitely. I'll do a whole analysis over everything. We'll take a look.
- [0:22:38] Speaker 4: Okay. Thank you. Thank you.
- [0:22:40] Speaker 3: Of course.
- [0:22:42] Speaker 4: Yeah. Thank you, Bryant. Okay, I will drop you in an email with the username and password. Thank you. Thank you.
- [0:22:49] Speaker 3: Bye, everyone.
- [0:22:50] Speaker 4: Thank you.
- [0:22:51] Speaker 3: Cheers. Bye.
