Working with go requires you to understand quite a bit of what the language
considers to be good code or good practice.

This is a **simple** overview of working with locks vs channels for shared memory
or concurrent work.

Trying to avoid channels has been my first instinct cause they honestly
can get confusing if you don't keep track of the flow mentally, and
there's no easy way to read them in code without going through it
a few times.

Most cases require a queue so here's a short snippet for it

```go
package main

import "log"

func main(){
	in:= make(chan string,1)
	out:= make(chan string,1)
	done := make(chan bool,1)
	go sender(in,out,done)
	go receiver(in,out)
	<-done
	close(in)
	close(out)
	close(done)
}

func sender(in,out chan string, done chan bool){
	for i:=0,i<10;i++{
		in <- "a random string"
		<-out
	}
	done<-true
}

func receiver(in,out chan string){
	for str := range in{
		log.Println(str)
		out <- str
	}
}
```

1. We define 3 channels, `in`,`out`,`done`
2. We setup 2 routines, one being the sender and one being the receiver,
   in most cases the sender won't be inside another routine but for the sake
   of understanding this, we'll do so.
3. The receiver's work is to just monitor signals from the channel which
   are being passed as the primitive type `string` and can be looped upon
4. in the same receiver, we perform some action with the received signal
   and notify the sender that the action has been done, by sending a signal into the `out` channel
5. finally once the sender is done with all it's cases, we send a signal
   to the `done` key to notify the `main` function to stop waiting for it and execute the lines after the `<-done`
6. at this point, we are just closing all 3 signals since we are done with them.

The point of this or why go considers this to be better practice is because
you don't lock the shared memory, instead you lock the program to wait for the
memory reference to be sent to you, this the code more concise when compared to
doing this with the Mutual Exclusion Objects (mutex) or simply put, an access lock.

the same thing above would need a mutex on each string that's being accessed,
needs to be locked and unlocked before an action is performed and you have to be careful
about it since if something is being written without the lock then you loose the
concurrency but the mutex approach is much more readable since you know that you
dealing with a lock and it's mostly right in the typedef of the variable you
are dealing with.

Channels on the other hand if not thought through can be a mess to find and
understand, for a simple thing like a queue, this is fine.

If I were to deal with a granular execution control between threads, I'd be crying
right now.

The solution is to maintain custom queues and each queue having it's own listener, with jobs
being passed to it

This keeps your channels easier to understand even in case of granular control flows, having a
generic implementation of the queue that hides the channel communication for you
should reduce the readability stress and keep the code concise.
