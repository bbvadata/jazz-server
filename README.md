## What is Jazz

Jazz is a lightweight analytical web server for data-driven applications. It provides data persistence and computation capabilities accessible
through a REST API. It is meant for solutions that need to rely on fast processing, scalable and reliable open source C and C++ libraries.
A Jazz server installs in less than a minute and has a startup time of less than a second. It integrates with R, Python or any API capable
software.


## History and Objectives

Jazz started as a research project on fast data processing servers led by Santiago Basaldúa at BBVA Data & Analytics that evolved into an
analytical web server. In September 2017 the source code of the server and the R client was released under an Apache 2.0 license. Today,
the aim of the project is to pivot the original design into a lightweight server oriented to make machine learning available through APIs.

We welcome developers to improve Jazz and contribute to the project particularly for the features mentioned in [development](DEVELOPMENT.md).


## Getting Started

Get your Jazz server up and running.


#### Compile the server from source code and run it

 - Make sure you have access to the linked libraries (see [prerequisites](REQUISITES.md))
 - make jazz (This makes the development library)
 - ./bin_debug/jazz start (This starts a debug server at localhost:8888)


#### Open an R session to connect to the server

	library(rjazz)

	content <- '<html><body><h2>Hello world!</h2></body></html>'

	create_web_resource('my_app','/hello/hello.html',
						type_const[['BLOCKTYPE_RAW_MIME_HTML']],
						content, lang = 'en-US')


#### Connect using a web browser

Now, if you open localhost:8888/hello/hello.html in your favorite web browser, you will see the page you just uploaded. Congrats!


## Learn more

 - See the R clients manual by typing ?rjazz at your R console.
 - See [development](DEVELOPMENT.md) for information on features and their development status.


## Contributing

Contributions are welcome, see [CONTRIBUTING](CONTRIBUTING.md) for details.


## License

Jazz is available under an Apache 2.0 license, see [LICENSE](LICENSE.md) for details.


## Acknowledgments
Special thanks to Roberto Maestre who has been discussing the idea giving valuable feedback since the beginning, the members of the BBVA Software
Engineering Core, especially Manuel Valdés and César de Pablo, for their feedback, the BBVA Data and Open Innovation Platforms team, especially
Óscar Tomás and Ángel Puerto, for the hardware and their feedback, Jose Antonio Rodriguez who organized the initial presentation to the UI team,
as well as BBVA labs for their feedback and help with the legal issues.
