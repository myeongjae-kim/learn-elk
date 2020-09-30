import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.3.4.RELEASE"
    id("io.spring.dependency-management") version "1.0.10.RELEASE"
    kotlin("jvm") version "1.3.72"
    kotlin("plugin.spring") version "1.3.72"
}

group = "org.kiworkshop.learnelk"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
    mavenCentral()
}

object Versions {
    const val slf4jApi = "1.7.30"
    const val logback  = "1.2.3"
    const val coroutines = "1.3.9-native-mt-2"
    const val logbackEncoder = "6.4"
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.springframework.boot:spring-boot-starter-webflux")
    implementation("org.slf4j:slf4j-api:${Versions.slf4jApi}")
    implementation("ch.qos.logback:logback-classic:${Versions.logback}")
    implementation("ch.qos.logback:logback-core:${Versions.logback}")
    implementation("net.logstash.logback:logstash-logback-encoder:${Versions.logbackEncoder}")

    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:${Versions.coroutines}")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-reactor:${Versions.coroutines}")

    developmentOnly("org.springframework.boot:spring-boot-devtools")
    testImplementation("org.springframework.boot:spring-boot-starter-test") {
        exclude(group = "org.junit.vintage", module = "junit-vintage-engine")
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "11"
    }
}

tasks.bootRun {
    jvmArgs = listOf("-Dreactor.netty.http.server.accessLogEnabled=true")
}
