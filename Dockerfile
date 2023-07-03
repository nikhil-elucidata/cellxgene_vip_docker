FROM continuumio/miniconda3
ARG DEBIAN_FRONTEND=noninteractive

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN export LC_ALL='en_US.UTF-8'


RUN \
    apt-get update -y && apt-get install -y cpio libcairo2-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \ 
    && apt-get clean

COPY cellxgene_VIP cellxgene_VIP

# Move into cellxgene_VIP directory
WORKDIR cellxgene_VIP

# Switch to bash terminal to run "conda" commands
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y build-essential libxml2-dev python3-dev python3-pip zlib1g-dev python3-requests python3-aiohttp git && \
    python3 -m pip install --upgrade pip

RUN pip3 install polly-python
RUN apt-get install wget
RUN conda install -c conda-forge uwsgi -y

#SETTING UP server for production
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx


RUN \
    apt-get update -y &&  apt-get install python3-pip -y && pip3 install --upgrade pip &&  apt-get install python3-dev -y && apt-get install build-essential -y

RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda config --set channel_priority flexible && \
    # Create and activate conda envirnment
    conda env create -n VIP --file VIP_conda_R.yml && \
    conda clean -afy && \
    conda activate VIP && \
    # Install VIP plugin
    ./config.sh && \
	  export LIBARROW_MINIMAL=false && \
    # Install R Packages and dependencies
    conda install -y -c conda-forge r-curl curl libcurl r-ragg && \
    R -q -e 'if(!require(devtools)) install.packages("devtools",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(Cairo)) devtools::install_version("Cairo",version="1.5-12",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(foreign)) devtools::install_version("foreign",version="0.8-76",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(ggpubr)) devtools::install_version("ggpubr",version="0.3.0",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(ggrastr)) devtools::install_version("ggrastr",version="0.1.9",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(arrow)) devtools::install_version("arrow",version="2.0.0",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(Seurat)) devtools::install_version("Seurat",version="3.2.3",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(rmarkdown)) devtools::install_version("rmarkdown",version="2.5",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(tidyverse)) devtools::install_version("tidyverse",version="1.3.0",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(viridis)) devtools::install_version("viridis",version="0.5.1",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(hexbin)) devtools::install_version("hexbin",version="1.28.2",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(ggforce)) devtools::install_version("ggforce",version="0.3.3",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(Rcpproll)) devtools::install_version("RcppRoll",version="0.3.0",repos = "http://cran.r-project.org")' && \
    R -q -e 'if(!require(fastmatch)) devtools::install_version("fastmatch",version="1.1-3",repos = "http://cran.r-project.org")' && \
    R -q -e 'if(!require(Biocmanager)) devtools::install_version("BiocManager",version="1.30.10",repos = "http://cran.us.r-project.org")' && \
    R -q -e 'if(!require(fgsea)) BiocManager::install("fgsea")' && \
    R -q -e 'if(!require(rtracklayer)) BiocManager::install("rtracklayer")' && \
    # Update anndata to 0.8.0
    pip install anndata==0.8.0 && \
    # Remove unused packages
    conda clean -afy

WORKDIR /

RUN mkdir /test-files
COPY pbmc3k.h5ad /test-files/file.h5ad
# Setting to download the file
COPY polly_script.py ./polly_script.py
RUN chmod +x ./polly_script.py

RUN apt-get -yq install net-tools nginx

# COPY cellxgene /etc/nginx/sites-available/cellxgene
# RUN rm /etc/nginx/sites-enabled/default
# RUN ln -s /etc/nginx/sites-available/cellxgene /etc/nginx/sites-enabled

COPY run_remote.sh ./run_remote.sh
# COPY index.html index.html
RUN chmod +x ./run_remote.sh

# COPY cellxgene /etc/nginx/sites-available/cellxgene
# RUN rm /etc/nginx/sites-enabled/default

ENV PATH /opt/conda/envs/VIP/bin:$PATH
ENV CONDA_DEFAULT_ENV VIP

ENTRYPOINT ["./run_remote.sh" ]