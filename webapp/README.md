# Webapp for studying ELK Stack.

## Webapp Spec

- Kotlin
- Spring Webflux
  - [Functional Endpoint with Coroutines router DSL](https://docs.spring.io/spring-framework/docs/5.2.9.RELEASE/spring-framework-reference/web-reactive.html#webflux-fn)
- Logback

## Run with profiles

- Logger prints logs on the console when `local` is one of active profiles. 
- Logger saves logs to `spring/spring.log` and `netty/access_log.log` files when `prod` is one of active profiles.

### Gradle wrapper

```kt
// build.gradle.kts
tasks.bootRun {
    jvmArgs = listOf("-Dreactor.netty.http.server.accessLogEnabled=true")
}
```

```sh
# For `local` profile, just bootRun. `local` is the default profile.
./gradlew bootRun

# For `prod` profile.
./gradlew bootRun --args='--spring.profiles.active=prod'
```

### Jar

```sh
# `local`
java -Dreactor.netty.http.server.accessLogEnabled=true -jar webapp-0.0.1-SNAPSHOT.jar

# `prod`
java -Dreactor.netty.http.server.accessLogEnabled=true -jar webapp-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

## Endpoints

```sh
curl localhost:8080/logs/error
curl localhost:8080/logs/warn
curl localhost:8080/logs/info
curl localhost:8080/logs/debug
curl localhost:8080/logs/trace
```

## References

- [Spring Webflux Functional Endpoint](https://docs.spring.io/spring-framework/docs/5.2.9.RELEASE/spring-framework-reference/web-reactive.html#webflux-fn)
- [Idiomatic Logging in Kotlin](https://www.baeldung.com/kotlin-logging)
- [Going Reactive with Spring, Coroutines and Kotlin Flow](https://spring.io/blog/2019/04/12/going-reactive-with-spring-coroutines-and-kotlin-flow)
- [Non-Blocking Spring Boot with Kotlin Coroutines](https://www.baeldung.com/spring-boot-kotlin-coroutines)
- [Logback AsyncAppender](http://logback.qos.ch/manual/appenders.html#AsyncAppender)
