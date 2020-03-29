package com.topaz.azure

import org.slf4j.{Logger, LoggerFactory}

object Program extends App {
  private val logger: Logger = LoggerFactory.getLogger(this.getClass)

  var n: Long = 0

  while (true) {
    logger.warn(s"Warn log $n")
    logger.debug(s"Debug log $n")
    n += 1
    Thread.sleep(1000)
  }
}
