FROM openjdk:11
COPY build/libs/jb-hello-world-0.1.0.jar hello.jar
CMD ['java -jar hello.jar']
