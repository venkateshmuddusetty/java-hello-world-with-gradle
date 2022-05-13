FROM openjdk:11
COPY build/libs/jb-hello-world-0.1.0.jar hellow.jar
CMD ['java -jar hello.jar']
