package org.kiworkshop.learnelk.webapp.config

import org.kiworkshop.learnelk.webapp.log.api.logHandlerRoute
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.reactive.config.EnableWebFlux
import org.springframework.web.reactive.config.WebFluxConfigurer
import org.springframework.web.reactive.function.server.RouterFunction
import org.springframework.web.reactive.function.server.ServerResponse

@Configuration
@EnableWebFlux
class WebConfig : WebFluxConfigurer {

    @Bean
    fun route(): RouterFunction<ServerResponse> = logHandlerRoute
}
