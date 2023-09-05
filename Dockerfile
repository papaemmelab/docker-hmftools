FROM rocker/r-ver:4.1

USER root

RUN apt-get update && \
    apt-get install -yqq \
    wget \
    curl \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libpng16-16 \
    libpng-dev \
    libjpeg-turbo8 \
    libjpeg-turbo8-dev \
    libfreetype6 \
    libfreetype6-dev \
    libgd3 \
    libgd-dev \
    perl \
    build-essential \
    openjdk-11-jdk \
    cpanminus \
    locales && \
    apt-get clean && \
    \
    # configure locale, see https://github.com/rocker-org/rocker/issues/19
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

RUN \
    wget https://github.com/hartwigmedical/hmftools/releases/download/cobalt-v1.13/cobalt-1.13.jar && \
    mv cobalt-1.13.jar /usr/bin/cobalt-1.13.jar && \
    echo "java -jar /usr/bin/cobalt-1.13.jar \$@" > /usr/bin/cobalt && \
    chmod +x /usr/bin/cobalt
    
RUN \
    wget https://github.com/hartwigmedical/hmftools/releases/download/amber-v3.9/amber-3.9.jar && \
    mv amber-3.9.jar /usr/bin/amber-3.9.jar && \
    echo "java -jar /usr/bin/amber-3.9.jar \$@" > /usr/bin/amber && \
    chmod +x /usr/bin/amber

RUN \
    wget https://github.com/hartwigmedical/hmftools/releases/download/gripss-v2.3.2/gripss_v2.3.2.jar \
    && mv gripss_v2.3.2.jar /usr/bin/gripss_v2.3.2.jar \
    && echo "java -jar /usr/bin/gripss_v2.3.2.jar \$@" > /usr/bin/gripss \
    && chmod +x /usr/bin/gripss

RUN \
    wget https://github.com/hartwigmedical/hmftools/releases/download/purple-v3.7.2/purple_v3.7.2.jar \
    && mv purple_v3.7.2.jar /usr/bin/purple_v3.7.2.jar \
    && echo "java -jar /usr/bin/purple_v3.7.2.jar \$@" > /usr/bin/purple \
    && chmod +x /usr/bin/purple

RUN \
    wget https://github.com/hartwigmedical/hmftools/releases/download/lilac-v1.4.2/lilac_v1.4.2.jar \
    && mv lilac_v1.4.2.jar /usr/bin/lilac_v1.4.2.jar \
    && echo "java -jar /usr/bin/lilac_v1.4.2.jar \$@" > /usr/bin/lilac \
    && chmod +x /usr/bin/lilac

RUN \
    wget https://github.com/hartwigmedical/hmftools/releases/download/linx-v1.24/linx_v1.24.jar \
    && mv linx_v1.24.jar /usr/bin/linx_v1.24.jar \
    && echo "java -jar /usr/bin/linx_v1.24.jar \$@" > /usr/bin/linx \
    && chmod +x /usr/bin/linx

RUN R -e "install.packages(c('dplyr','ggplot2','cowplot','BiocManager'));"
RUN R -e "install.packages('BiocManager')"
RUN R -e "BiocManager::install(c('VariantAnnotation','copynumber'), ask = F)"

RUN cpanm --no-wget --notest List::MoreUtils Math::Bezier Math::Round Math::VecStat \
    Params::Validate Readonly Regexp::Common SVG Set::IntSpan Statistics::Basic \
    Text::Format Clone Config::General Font::TTF::Font GD

ENV CIRCOS_VERSION 0.69-2

RUN cd /opt && \
    wget  http://circos.ca/distribution/circos-${CIRCOS_VERSION}.tgz && \
    tar xfz circos-${CIRCOS_VERSION}.tgz && \
    rm circos-${CIRCOS_VERSION}.tgz

ENV PATH /opt/circos-${CIRCOS_VERSION}/bin:$PATH

ENTRYPOINT ["bash"]
