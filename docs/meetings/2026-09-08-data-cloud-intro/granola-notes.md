# Granola notes and transcript: Data Cloud unified profile setup

- Source: Granola, folder "Sierra Circuts"
- Meeting: 2026-09-08 8:00 AM CDT
- Captured by: Bryant Daniels
- Speaker key: "Bryant" = note taker (Granola label "Me"). "Them" = unnamed remote voice.

## Granola summary

### Meeting context

- Intro call with Veena, Bikramaditya, and Vyankatesh (technical team) on their Salesforce Data Cloud setup
- Lewis originally had access and handed it over to Bryant this morning
- Bikramaditya led the screen share walkthrough

### Data Cloud setup overview

- Data ingested from Snowflake via zero-copy into Data Cloud
  - Sources include: contacts, leads, accounts, engagement activity, outreach activity
  - Each table carries one of three unique identifiers: Lead ID, Member ID (MID), or Email ID
- DMO mapping completed, custom DMOs created where native ones did not exist
- Relationships established between source tables and DMOs
- Identity resolution rules created with fuzzy matching on name, email, and phone
- Calculated insights built for intent score KPIs (two calculations created)
- Unified profile created with CRM ID / unified individual ID

### Issues identified

- Profile Explorer showing limited data: injected source table fields not appearing
  - Support team flagged that something needs to be configured in Data Graph
- Data Graph access blocked: error states "you don't have access to all objects and fields, contact your Salesforce admin"
  - Affects ability to add Salesforce objects (e.g., Lead, Contact) to the data model
- Native Salesforce Lead and Contact object data also not visible in Profile Explorer
- Goal: unified view in Profile Explorer showing company, contacts, leads, engagement, and marketing activity under one account

### Zero-copy schema change issue

- Some source columns showing as "not exist" after upstream Snowflake schema changes
- Bikramaditya's workaround: created duplicate columns with new names, mapped those, left broken columns unmapped
  - Bryant confirmed this is a valid workaround
- Cleaner fix: update API names at the DLO level, but requires unmapping everything first
- Recommendation: open a Salesforce support case to investigate why schema changes are breaking the zero-copy sync

### Next steps

- Provide Bryant with org access credentials (Bikramaditya). Username and password via email; access needed for 2-3 days.
- Analyze Profile Explorer and Data Graph configuration (Bryant). Report findings before making any changes.
- Open Salesforce support case for zero-copy schema sync failures.

## Transcript

- Veena: Hey, hi,
- Bryant: Hey, how's it going?
- Veena: Doing good. How are you?
- Bryant: Good, good.
- Veena: I think still people have to join from my end.
- Bryant: Okay.
- Veena: Yeah. Is Lewis joining or you are the one?
- Bryant: I'm. Not. I think Lewis might. I'm not positive. I know he gave me the access to the video, so I'm not sure if he's showing up or not. But I know we're doing just some introductions. And yeah, just join in the team. So I'm here to help out. And I think access and a few other things.
- Veena: Okay. Let me remind them since the.
- Bryant: All right.
- Veena: Screen is. By the time they join, I can give a summary. I think you might have gone through the email, right? So we created that profile, unified profile and all those stuff, but we are not able to see, you know, our deals, DMOs and all setup has been done. But due to that Graphics one unified profile where we can search and then can see the information of everything, right, that we are not able to see.
- Bryant: Okay. Okay.
- Them: I think this accent.
- Bryant: I have a bit of the email thread, so I don't know if I have all of it. What I have, what was kind of summed up from like Google AI or something? Like that was that, let me see if I can find it.
- Veena: You know, just accept, I think people are waiting in the lobby. I think I don't see it. Do you see?
- Bryant: I don't, I just see one guess. I see people just only you and me join.
- Veena: They're saying it's showing in the lobby? You have to accept that. I don't see it here anyway.
- Bryant: I don't see that. That's what I'm saying. I don't see anyone in the lobby. I saw you in the lobby and I accepted, but I don't. The only guest I see in the, yeah, let me, I guess maybe I could log out or can you give them this meeting link? We can try that.
- Veena: This thing. I mean, there is another link here somewhere I can share it.
- Bryant: I can give them this one to make sure they have the right one. I can give it to you because that's what I'm saying is I don't have anything that's saying allow people to get in.
- Them: Can you just ping here again? Again.
- Bryant: Yeah. Here you go.
- Veena: In the chat.
- Bryant: There we go.
- Veena: Okay.
- Bryant: Yeah. I don't know if it's because Lewis had it and gave it over to me this morning. But yeah.
- Them: Hello.
- Bikramaditya: Hi, everyone.
- Veena: Here we come. So become is the person who worked on this. I mean, and these two people are the technical guys. I think they can show you and they can explain the summary. And then where the problem is.
- Bryant: Okay.
- Veena: Can you go ahead and share the screen and then expect to know what you have done first? And then in any quick way. And then you can show him like, you know, what is the issue?
- Bikramaditya: It's not allowing me to share my screen. Okay, now. Can you see my screen?
- Bryant: Yes.
- Bikramaditya: Yeah. So, so I will start from the scratch where we started. Okay.
- Bryant: Okay.
- Bikramaditya: So you see, right different Source we have injected the data. Okay. Currently I'm not refreshing this data because as we were creating, right. So the first time only I refresh the data. After that, I'm not refreshing currently. Okay. Once everything done, then I thought of refreshing that that's not an issue. Right? Creating the next steps. Okay. After that, I, I have done everything, the mapping with the dll to DMO. Okay. Like it's a different Source table with our native TMOs or if it is not there, we have created in a custom one. If you see, I have opened the custom one and that I create a relationship between those two tables as well. Okay. After creation of the data stream, okay, we have checked in the data Explorer. BC is table data is properly populated there, okay, in data Explorer. Okay. Then we created some conditions rules, identity utilization. Okay. If you see, like to check, we have only created for the DMO objects. Okay. Few DM objects I created. Okay. Where I just do the fuzzy maths and all. Name and email and phone and emails. Okay. Those are the fuzzing mates I I'm doing currently. Okay. Then we have some few calculations which we created. Okay. So you can see right for the score wise intent score kpis. We created two users already in seat calculations. Okay. These are the calculation we created. Okay, so after that, I just wanted to, like, see the information in the profile Explorer. Okay, so we have created an a CMR ID unified ID. Okay. So when we select and go to the new white individual ID, okay. Say any first name wise I'm searching. So currently, if you see the information, what I see it here, it's a limited information. Okay. I don't see if stable whatever the source table I have injected, those all information I don't see in the profile Explorer. Okay. I was checking with the support team. So they told me something need to be created in data graph. Okay, so while I exploring the data graph, okay, I will go there. Meanwhile, it's loading. Yeah. So in the data model, when I try to add my Salesforce objects, like suppose say lead. I don't see the lead one. Okay, then see contacts. So above you see the message, right? You can't view or create data graph because you don't have access to all apps and fields contact your sales course admin. So whenever I search any objects, I get this. This is an error. Okay.
- Bryant: Okay. Okay. All right.
- Bikramaditya: And come to. Okay, let's pause here and go to the profile Explorer and see. So activities I don't see calculated Insight. I don't see. Okay. How exactly we wanted to see the profile Explorer in our database where different database we have company information, contact information, right? Lead information, then against engagement, Market to activity, Outreach activity. So we want in the profile explore everything should be in one place. Okay. Based on. Okay, this is the account ID and this is the company. Then under that we have this many contacts and leads. Okay. That's the flow we will looking to achieve in the profile Explorer.
- Bryant: One question I did have. Can you go back to your data streams? Can you do all of them instead of the recently viewed?
- Bikramaditya: Sorry. Your voice is low. Can you repeat?
- Bryant: Can you do all of them instead of the recently viewed in the pick list?
- Bikramaditya: All of them?
- Bryant: Yeah. Do you right up top right at there where it says recently viewed?
- Bikramaditya: Okay. Okay.
- Bryant: Yeah, yeah, yeah, yeah. So I was just looking. So you're bringing in snowflake, right, as well.
- Bikramaditya: All data streams. Yes.
- Bryant: Is that information needing to come in as how is it set up currently? Is it or does that need to come in? You know what I mean? Like I noticed that because the accounts and contacts, I understand that when the leads as well. But if there's any other information that needs to be on that profile page like engagement activity, are you grabbing it from here? Are we doing it just from like the engagements that's coming in from the lead activity?
- Them: So.
- Bikramaditya: The source, whatever you see different source, that is actually snowflake is the one source where we created different table. So engagement activity contacts. Okay. All those different activities and using the zero copy, we injected the data and while injecting wherever the engagement data we choose as a engagement, wherever activity data we choose the activity, then be injected.
- Bryant: So on that snowflake on those, when you have accounts and contacts, is there an identifier from snowflake that we're able to use as a unique identifier to establish, can you show it to, can you tell me what it is or show it to me?
- Them: Yes. Okay.
- Bikramaditya: So here you see right the lead ID lead ID we have the primary key like which is in the our snowflake table. Okay. Mit also. Okay. And also what we added in Salesforce, we have an ID, right? That ID we were keeping in each table in the snowflake as well. So that also be injected.
- Bryant: ID? Okay. Okay. Okay. All right. And for the other streams, do they all have either the lead ID, MID or sorry? Okay, so they all have.
- Them: Yeah.
- Bikramaditya: So if every table have the lead ID. Sorry. Lead ID or email ID or member ID. There's three.
- Bryant: Okay. Yeah. Okay. Okay, so you're having a problem seeing the objects and that and the profile. Okay. Sorry. I have a little sheet of questions. You're actually already answered most of them. Okay, what about, what, what else as far as like calculated insights? Are you all using those or segments that need to be looked at? It sounds like just the objects and the data craft that you're having a problem with currently and leveraging that. Are you trying to use any related list or anything on some of the accounts and contacts in the CRM? Or that'll probably be solved after we get this relationship actually.
- Bikramaditya: Yes. Yes. So mostly if you see the data in the day profile Explorer, okay, behalf of Salesforce lead and contact object. Right. So that also we have relation. Right. But I don't see those information as well. So let's skip about now for the injected data. But the account lead and contact object information also in the profile Explorer. We not able to see.
- Bryant: Working out of prod production?
- Bikramaditya: Yeah.
- Bryant: Okay. So I guess next steps, I would just need access to get in there and then just do a little analysis. I won't be changing anything until I show you all what's going on there. And then we can kind of go from there if that's okay.
- Bikramaditya: So when, when you ask for an user, so like what we do normally when we connect to support, we give access for one, two days, right from our user only. So likewise you are looking or in a username password directly you wanted to access.
- Bryant: So I'm not with like Salesforce support. I'm with kicksaw. So however they implemented it before, I don't know if they open up. I've never done the support system. I know what you mean by opening up for support with Salesforce, but I haven't done it with just us. And I only need like two days, two or three days.
- Bikramaditya: Okay. Okay. So let me my Salesforce team. I ask to share with you the informations. Okay. But you understand where we have the pain points right in the profile Explorer in the data. Those are the two. Also I have another question. As already I have Googled it and find out the answers, but I just trying to understand say when we inject the data as a zero copy. Okay. In the source table. If anything changes, I see there is an issue on the tables. Okay. It is a failing to rephrase.
- Bryant: Okay. Yeah. Generally that happens when a metadata change happens from the source. So if it's like. Maybe going from text to a number could change it or even add in a field. What I've known in my implementations is that data cloud can be very finicky. So a lot of times if something's changed in the source, you have to make sure that it's updated in Salesforce. Because a lot of those moving parts are connected. Is that happening right now?
- Bikramaditya: Yes. I have handled it in the different way, but I just wanted a so.
- Bryant: Did you have to delete everything and then put it? Okay.
- Bikramaditya: No, no, no. So if you see these columns, right count and fame's order exists. These are, these are showing it's not exist actually. But before it is exist and as it is a took as a photocopy, I am able to see it this columns. But what I did, it was allowing me to add new columns. Okay, so these columns I named it different and added it and mapped it properly. And I'm just keeping those columns here. Whatever already there, which is showing like not exist.
- Bryant: I see what you're.
- Bikramaditya: Is that a good practice to do or there is any other way?
- Bryant: Looking just to get rid of them. Entirely. Or just trying to like see if the order exists or has completed. Or are you asking if it's okay to leave them there without them being mapped?
- Bikramaditya: No. What I'm saying. So suppose say this column, right? Fence order. He says it not exist column. Right. Due to the changes happened in the source table.
- Bryant: That's what you're asking. Okay.
- Bikramaditya: So what I did instead this column is not referencing and it's not allowing me. So I created a duplicate column called femce order exist. Okay. That I pushed and added as a new column because it is allowing me to add new columns. But if there isn't changes, it was not updating. So I mapped that copied column. Duplicate one and I left as it is the existing column.
- Bryant: Gotcha. Yeah, that is one way to work around that. The other way is you could probably go to the DLO and update it. Just update the API names. But in order to do that, you'd have to unmap a lot of stuff.
- Bikramaditya: Yes. Yes.
- Bryant: So yeah, right. So like that's why I said that's a good workaround for that. Um, but it shouldn't be happening that often. Um, we could probably open up a case with Salesforce to understand why it's like airy now because you don't have to do that all the time whenever it updates like that. So I would open up a case to see why.
- Them: Thank you.
- Bikramaditya: Yeah, that's from my end. We'll save you after this call. The user details. Okay. And if still have any questions for me, you can drop me in an email. I will reply. Okay.
- Bryant: Do you have any questions for me?
- Bikramaditya: No, from my end. I'm good.
- Bryant: Alrighty.
- Them: Thanks. Yeah.
- Bryant: Cool. Yeah. So yeah, once I get access, I'll start digging in getting these profiles connected and stuff. So I'll look in and to see what's going on. And get back with you.
- Bikramaditya: Okay. Okay. And please let us know if there is any best practice which we were missing. Okay.
- Bryant: Yeah definitely I'll do a whole analysis over everything. We'll take a look.
- Them: Okay. Thank you.
- Bryant: Yeah. Worse.
- Bikramaditya: Thank you. Okay, I will drop you in an email with the username and password. Thank you.
- Bryant: Okay.
- Them: Thank you.
- Bryant: Thanks everyone. Cheers bye.
