# Unified configurations

Now, I don't have a think against yaml, ini, or toml and they
all work well but for stuff that you can't pass via CLI options and for
more permanent configuration.

I'm not against that but then the cli code has to take into consideration
parsing both the toml and the cli flags and decide priority / merge them etc etc.

Here's how I plan to get it to work and it's not an original idea (obviously!
not a genius.).

If you've used [`ytdl`](https://github.com/ytdl-org/youtube-dl) the original
library then it uses the cli flags as configuration by passing a youtube-dl.conf file either locally or in one of the many user / global configuration directories and that's perfect.

You get to keep a single layer of default values and single level of parsing, unless you allow multiple values for the same argument, then maybe a little more parsing but most libs support that.

### Tips when building one

This section will be updated once the above has been done for golang for a few of my tools
