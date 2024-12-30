FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
LABEL authors="sd1172@srmist.edu.in" \
      description="Docker image containing all requirements for the LncConserve pipeline"

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    bash \
    curl \
    wget \
    git \
    bzip2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* 

# Install miniforge
RUN curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o miniforge.sh \
    && chmod +x miniforge.sh \
    && bash miniforge.sh -b -p /opt/miniforge \
    && rm miniforge.sh

# Set environment variables for miniforge
ENV PATH="/opt/miniforge/bin:${PATH}"

# Install Conda environments
COPY LncConserve.yml /tmp/
RUN mamba env update --file /tmp/LncConserve.yml && conda clean -a

# Slncky environment
COPY slncky.yml /tmp/
RUN mamba env create --file /tmp/slncky.yml && conda clean -a

# Install Slncky to path
COPY utils/slncky/slncky.v1.0 utils/slncky/alignTranscripts1.0 /opt/miniforge/envs/slncky/bin/
RUN chmod +x /opt/miniforge/envs/slncky/bin/slncky.v1.0 \
    && chmod +x /opt/miniforge/envs/slncky/bin/alignTranscripts1.0 \
    && chmod -R 777 /opt/miniforge/envs/slncky/lib/python2.7/

# Create a directory for LncConserve
WORKDIR /pipeline
RUN mkdir LncConserve

# Copy LncConserve
COPY . /pipeline/LncConserve

# Copy and run the script to add paths for tools
COPY add_paths_for_tools.sh /tmp/
RUN chmod +x /tmp/add_paths_for_tools.sh && bash /tmp/add_paths_for_tools.sh > $(pwd)/LncConserve/tools.groovy

# Default command to start a bash shell
CMD ["bash"]
