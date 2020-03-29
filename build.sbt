enablePlugins(JavaAppPackaging)

name := "scala-azure-logging-sample"

maintainer := "info@topaz.technology"

version := "0.1"

scalaVersion := "2.12.10"

libraryDependencies ++= Seq(
  "ch.qos.logback" % "logback-classic" % "1.2.3",
  "com.microsoft.azure" % "applicationinsights-logging-logback" % "2.6.0",
)
