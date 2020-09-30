package org.kiworkshop.learnelk.webapp.log.api

import org.slf4j.LoggerFactory
import org.springframework.web.reactive.function.server.ServerRequest
import org.springframework.web.reactive.function.server.ServerResponse
import org.springframework.web.reactive.function.server.buildAndAwait
import org.springframework.web.reactive.function.server.coRouter

const val PATH = "/logs"

val handler = LogHandler()

val logHandlerRoute = coRouter {
    GET("$PATH/error", handler::error)
    GET("$PATH/warn", handler::warn)
    GET("$PATH/info", handler::info)
    GET("$PATH/debug", handler::debug)
    GET("$PATH/trace", handler::trace)
}

@Suppress("UNUSED_PARAMETER")
class LogHandler {
    companion object {
        private val logger = LoggerFactory.getLogger(LogHandler::class.java)
    }

    suspend fun error(request: ServerRequest): ServerResponse {
        logger.error(">> error message <<")
        return ServerResponse.ok().buildAndAwait()
    }

    suspend fun warn(request: ServerRequest): ServerResponse {
        logger.warn(">> warning message <<")
        return ServerResponse.ok().buildAndAwait()
    }

    suspend fun info(request: ServerRequest): ServerResponse {
        logger.info(">> info message <<")
        return ServerResponse.ok().buildAndAwait()
    }

    suspend fun debug(request: ServerRequest): ServerResponse {
        logger.debug(">> debug message <<")
        return ServerResponse.ok().buildAndAwait()
    }

    suspend fun trace(request: ServerRequest): ServerResponse {
        logger.trace(">> trace message <<")
        return ServerResponse.ok().buildAndAwait()
    }
}
