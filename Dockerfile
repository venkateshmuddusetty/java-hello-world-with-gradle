FROM alpine:latest
RUN apt --update add openjdk8-jre
COPY target/*.jar hellow.jar
CMD ['java -jar hello.jar']
