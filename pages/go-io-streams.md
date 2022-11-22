Most of go lang's lower level functionality is written similar to how
C would handle them other than having to manually allocate memory for these things.

Though, it doesn't mean you can't, a predefined buffer size is used if you don't define how much buffer you wish for go lang to use.

Linux (even most Unix) use files as both files and directory and also references to running processes,[more about this](undone)

Which means, when go handles the same, it tries to first get a file descriptor ( simply an id pointer to request the OS to give permission to read / write the file)
and then when you do a `ReadFile` it's opened with the read permissions and `WriteFile` gives you a wrapper which requests a open and then writes to it in streams.

Similar to how we [handle channels for shared memory](shared-memory-and-go), a file descriptor can be shared around and is smaller than sending around the file descriptors instance.

This allows you to read the file in buffers manually instead of just reading the entire thing in memory.

Ex:

```go
fileBytes, err := ioutil.ReadFile("path/to/file")
```

Here `fileBytes` would have `[]byte` data for the textual data of the file you read from, which will take up memory based on the size of the file, so if you are dealing with smaller files this is fine and it's basically how you'd move forward.

When working with larger files it's preferred to read them in chunks and pass around data in chunks.

You can do this by using the `io.Reader` compatible references to do this or you can use the `os.File` references, since it gives you the ability to reset back to the
start of the data and read it again if you wish to copy the same file's content to various outputs.

You can also process them in lines, for cases where each line process can be done (something like a text editor) or if working with chunks of data, you read till you find
the next character.

example a json decoder would look for the starting `{` and ending `}` and `[` and `]` tokens to get a complete json chunk before running conversion and will error out
when it doesn't find a valid chunk or fails on the first parse of the chunk.

This is also how most languages do it at lower level, even nodejs / ruby etc. The users (developers) are given higher level API's for most common cases
similar to how you have the option to use channels but you'll see most people just use waitgroup's instead which are internally an abstraction over the channels
concept.

So, when working with larger files or working with files of unknown sizes, make sure you take into consideration to work with partial buffers instead of taking
the entire file into memory
