
SETUP
==========================

WARNINGS
-------------------------
When assigning a strict host PORT as is the case with the deploy scripts.
Maestro likes to be dumb, it will not detect ip's already in use.
It will continue to try to deploy the application no matter what.
This could eat up hard disk space and leave you in a bad place.
Maybe in the future, there will be checks and balances, but for now
C'est la vie

Install docker-machine
--------------------------
https://docs.docker.com/machine/install-machine/

Start our dev machine
--------------------------
```bash
./init_machines.sh
```

Test env and connect if fail
--------------------------
```bash
docker ps
# if FAIL
eval $(docker-machine env c1)
```

Run start scripts for consul and maestro
--------------------------
```bash
./start_consul.sh
./start_maestro.sh

docker ps
```

Build images for our hello apps and the go-thrust-chat-server
--------------------------
```bash
./build_images.sh
```

Test access to consul
---------------------------
```bash
curl http://$(docker-machine ip c1):8500/

# <a href="/ui/">Moved Permanently</a>.
```


Test access to maestro
---------------------------
```bash
curl http://$(docker-machine ip c1):8080/
# Cannot GET /
```

Registering applications
--------------------------
Download and open up your favorite http client like Postman for Chrome

In ./fixtures you will find some json to get you started

Accessing Applications
--------------------------

It is relatively simple to create a Node/Go/Haproxy whatever you want, proxy for Consul services. I did not do it here, but have done
it for other architectures.

For now, simple access the consul ui

Navigate to http://mydockermachineip:8500/ui

From there access the nodes tab. Find your service and their ports and access

http://mydockermachineip:myserviceport


Zero Downtime Deployments
--------------------------

Zero DT Deployments, in this case, are executing by creating another application with a different image or image:tag combo and
deploying that application.

Basically the flow is like this

1. Deploy your first application
2. Change the code
3. Build the dockerfile with a different image:tag
4. Copy the first applications json, and modify the name and image
5. Deploy the new application
6. Now just change the original application's scale using another POST /applications to 0
7. Maestro will now scale down the old application.

Also I added the the SCRIPTS you asked for. But they break the tenet of zero downtime, since this system in architected around being behind
some kind of reverse proxy

To execute them
```bash
cd ./deploy
# command format is 
# ./{file} {scale (0|1) } {PORT} {version-name | optional} {old-version-name | to bring down to 0 scale automatically | optional}
./go.sh 1 9000 v1
./go.sh 1 9000 v2 v1
./lua.sh 1 9001 v1
./lua.sh 1 9001 v2 v1
./python.sh 1 9002 v1
./python.sh 1 9002 v2 v1
./go-thrust-chat.sh 1 9003 v1
./go-thrust-chat.sh 1 9003 v2 v1
```


Alternatives Zero DT methods
--------------------------
Code a deployments object. It will manage cycling deployments, and reverting.
It can exist at /deployments





ANSWERS TO OPS QUESTIONS
-------------------------

1. A realtime communication server tends to have lots of connections that can remain open for hours or even days. At some point after deploying a new server version, the old version has to terminate. How would you do this? Write up short descriptions of two or three methods, and indicate which you prefer and why.

A: This needs to be implemented from the top down. Every part of the stack needs to implement acknowledgements for all sends, and support retry logic.
 - Gracefull shutdown procedures.
 - Divide messages into durability levels and attach universally unique ids. Every system should know the last nth number of messages it received. This can be destributed via Redis are some other scalable hash based database instead of a btree database. Why hash? Because its fast, very fast, and good for things things that come in and out quickly, and expire quickly. It is especially efficient for implementing distributed state management.
 - Use a broker, like with RabbitMQ, and a Dead Letter Exchange. You will get the best in breed durability.

2. InnoDB clusters data in its primary key B+Tree. As a result, "natural primary key" tables and "auto-increment primary key" tables have different characteristics. In a few words, how would you describe the differences? Also, give at least one examples of when you would use natural keys over auto-incrementing ones.

A: I am not a DBA, but I will take a stab based on my knowledge.
  - InnoDB Clustered indexes embed data with the index. The benefit of this is such that because the index is sorted, you can do extremely fast seeks into the index and find all the data your looking for without extra cycles to disk. The problem is, secondary keys are expensive in this case. If you have a primary key that is surragate (i.e. no business value representation), then you have wasted your efficient key on a surrogate, when you could have used something more meaningful. However beware of large primary keys, as they can reduce the peformance of a clustered index.
  - One example of when to use natural keys over auto incrementing is when you can easily define a uniqueness weight in your data. Always examine your use cases, and how you expect to query, if you can identify it, then use that as your primary key, otherwise use auto_inc.

3. We strive for virtually 0 downtime, but shit does happen. If/when disaster strikes we have to respond immidately. Please take the time to describe how you would structure downtime alerts and human response protocols at a company like ASAPP in order to sleep soundly at night.
  - Alerts are neccessary, we would use a tool like Sensu / New Relic etcetera to monitor servers and applications.
  - Document escalation procedurs
  - Emails/ Cellphones etcetera
   - Most importantly, we would program a reactive infrastructure, one that can execute operations based on the current state of the system. Attempt to recover.
    - i.e. if a disk is becoming to full? can you purge data? no? okay lets stop that server and bring up a new one? okay this new one needs apps. No problem our orchestrator knows how many of an app it needs.
    - Running golang? no problem CPU autoscaling in an ASG is perfect enough. Attach that to ECS your good as gold.


4. Logs can be fantastic, and logs can be a headache. We have servers written in multiple languages, with multiple versions of each running in parallel on multiple machines that can be torn down and spun up at any time. In addition, PCI compliance requires long-lived access logs of all production services. How would you structure logging for this whole system?
  - One answer 
   - Lumberjack to ELK, with backups to S3 and permanent storage in Glacier. ( Multi Region of Course )

5. How do you feel about being point person and in-house expert on compliance? (PCI, HIPPA, etc.)
  - Honestly, I have done PCI, I understand HIPPA a little bit. I would be a point person, but I would never be the one source of truth. We would need advisors and certified consultants.



ANSWERS TO SYSTEMS ENGINEER QUESTIONS
---------------------------

- How will you scale your server beyond a single machine?

A:  Same as for OPS
  - Redis or some other Hash inmemory distributed store. Message Ids and acknowledgements. Use Maestro from ops test to deploy.

- How will you support a typical "home" screen which lists all conversations along with their most recent message?
    All conversations need to be up to date at all times.
    Consider the case where a device is offline for a day and comes back online.
    Also consider the possibility of a user having multiple devices.
    What if a user has had a total of ~1'000 conversations and goes online/offline frequently?

A: I am running out of time so I will keep this short, but know what i want to talk about this more.

  - Eagerness vs. Laziness.
  - Eagerness as in "Eager Joins" like twitter, post failure, are essentially the idea of
  fan out replication to feeds at message time. Anyone with a vested interest gets the message.
  - Laziness is queries. When a user has been away for far too long, instead of eagerness, 
  because that would be too much system effort. We use laziness with eagerness on top.



- Extra Qeustions


- How will you deploy new versions of your code without any downtime?
    Taking a box or process offline that still has open websocket connections is probably a Bad Idea (tm).

A: See OPS Answers


- How will you implement picture messages?
    Where is image data stored? How/when are thumbs generated? How are URLs decided on?

A: Depends on how deep down the rabbit hole you are willing to go. Do you want to be slack, and show old previews of pages. Or parse videos.
   Typically for just images, the easiest way, albeit heaviest is to Base64 encode the image, and decode it on the client side.
   Alternatively you could append metadata to the message to download the image for permanence, and send an internal link to the client.


- Imagine that Comcast will start directing their customer support traffic at your system a month from now. How do you prepare?
    They see roughly 1M conversations per day

A: We can pretty easily simulate this with ECS, it will be costly, but heh, Comcast will be paying us right? For 1M conversations, you are looking at 2M-2.2M
   connections. You are looking assuming at 1-3mb per connection. You will need a 2 - 7 Million Megabytes of memory distributed of course ( If you assume 1M through the whole day. You will need to prep your servers for high ulimits.

   - That is of course the worst case scenario. You are more likeley looking at determining comcasts hotspots. With cycling through the day for WestCoast EastCoast time diff. You will always see hotspots, so you can program pre-scaling for those time periods. AutoScaling for any unforseen rises, like citywide outages.

- How will your system handle a user with multiple devices gracefully?
    E.g imagine a user alternating between her laptop, her phone and her tablet.
    Also imagine a user who has used the service for 3 years and then adds a new device.

    - A user is a user is a user. There is no difference between devices. Does a user on a website have a different account of tablet and desktop.
    - As far as communcation accross devices, we just have to ensure that we 
