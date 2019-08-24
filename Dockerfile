FROM jupyter/minimal-notebook:2ce7c06a61a1

USER root

RUN apt-get update && apt-get install -y curl openjdk-8-jre

RUN SCALA_VERSION=2.12.8 ALMOND_VERSION=0.6.0 && cd /tmp && curl -Lo coursier https://git.io/coursier-cli \
&& chmod +x coursier \
&& ./coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond \
&& ./almond --install --global --id scala212 --display-name "Scala (2.12)" \
&& rm coursier almond \
&& cd /

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
RUN chown -R jovyan ${HOME}
USER jovyan
