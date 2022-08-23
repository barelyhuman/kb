React native has had quite some improvements and changes
but a lot of issues I've had involve getting it to work on
my M1 macbook, here's a few things to do.

**If you can't get it to find -lDoubleConversion**
You probably messed the `Podfile.lock`,
remove the file and the `Pods` folder. Then try to re-install
pods using `pod install` and see if it builds.

If not,
then remove the contents of `DerivedData`, which can be done like
so on any mac unless you changed it location.

```sh
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

**If there's a build issue and you are missing a module map**
If it's a package from the `react-native` library then you should just start a new react-native project on the side, copy it's `Podfile` and
then run `pod install` with that to see if it fixes it.

If it's a additional library or package you installed later, then you
should delete the `yarn.lock` file and try to pin down the version of
the package, remove `node_modules` and install both the node and ios packages.

```sh
rm -rf node_modules
rm -rf ios/Pods
yarn
cd ios; pod install; cd ..
```

