List of things that your production level setup
for webapp should have to make it easier to work with.

1. A global state handler. This is to make sure you can access any producer,datasource or service that might be needed throughout the app.
   A good example of this is the Loopback 3 codebase where the `App` points
   to the entire app's global state. You can bind functions to it, you can
   bind a data source, models, workers to it and that can be accessed throughout the
   app.

2. A producer consumer model for async or background tasks. The general
   practice is to not throw work on the same thread / process that is
   handling the network calls which can get blocking over time, so
   you move all the async or processes that don't need to be handled in realtime
   to a worker task. In languages where there's no thread separation, you can
   use another process that acts as the worker and this listens to events
   either from a message queue or a pub-sub model or another service altogether.

   Point being, you are able to send commands to this worker as needed. This helps
   with triggering emails, sms, generating reports , etc etc. Most of these
   as you can see are sub tasks to a network request and if they are added
   to a queue or event service, you offload and reduce the chances of an
   error blocking the system that's connected to the external world.

3. A non coupled functional model. This is more of an opinion but over time
   I've observed that I don't feel like refactoring when the function handles way
   to much of the data retrieval logic. Example, a large query , an ORM function
   that's trying to do everything and if the input and result of this query is
   tied down to everything in the method it makes it hard to refactor.

   So, I started moving everything logical into a separate function that would
   act as the data handler and it's work is to just return the data in a certain
   format. This leaves the ground open to being able to change ORM's when the
   author's stop maintaining them and also to make modifications in a smaller
   scope compared to the original `Controller handling everything scope`.

   I've been guilty of doing this even after knowing about the DDD based
   architectures because it seemed simple to just get the project started
   and working but then every time the code base needed a refactor or
   a feature that would go against the original written code, it'd get
   hard to do and the friction to get it working would push me away
   from doing it altogether. This is particularly true with TillWhen's
   codebase and also why it's been forever since I've worked or added
   something new to it.

4. Store the configuration files with the codebase. This is something that was common
   with traditional web codebases since it was a pain to have to go and modify
   the codebase on the server with SSH so whatever supporting tool configuration was
   required, was added in the codebase instead.

   Ex: Using nginx ? Add the `sites-enabled/project-name.com` config in the folder
   and your deploy script or update script would refresh the soft link with the
   original folder as required.

   Another example could be cron jobs, if you have a dedicated server for the application
   then the `cron.txt` or the crontab file is a part of the codebase and get's
   linked to the server's user crontab, this makes it easier to hack onto stuff locally
   and then deploy it instead.

   This might not be wise to do with things where you have secrets in the configuration
   so just do this for stuff that helps with deployment and not with stuff
   that configures external services. If you're using a private git repo, great but I'd
   still advise against storing such stuff in the repo altogether.

5. Environment setup scripts. This should be the first point. Write scripts
   to setup the environment for you. Need docker and docker compose? Add a script
   that installs it for you. This can be OS specific if needed but please add these
   to the codebase. This removes the friction of standing up a new environment
   when needed. I've got quite a few of these to setup postgres, elastic search
   and redis since they are very common in most of my production apps.

   Anything new that's needed is added to these setup scripts. If there's
   different configurations or setups for different environments, example, one for
   ubuntu and one for fedora then append that in the name of the script but
   please make setup scripts, you'll thank me later.

6. Simplify the deployment steps, having way to many ways to deploy
   will confuse you, have a simple setup and sync it across setups to
   see how much of a configuration havoc it is. If the deployment
   requires you to go through 100 configurations then that's not "easy to use".
