FROM nvidia/cuda:12.3.1-base-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive
ENV CMDARGS --listen
ENV CMDARGS="--listen"
ENV DATADIR="/content/data"
ENV config_path="/content/data/config.txt"
ENV config_example_path="/content/data/config_modification_tutorial.txt"
ENV path_checkpoints="/content/data/models/checkpoints/"
ENV path_loras="/content/data/models/loras/"
ENV path_embeddings="/content/data/models/embeddings/"
ENV path_vae_approx="/content/data/models/vae_approx/"
ENV path_upscale_models="/content/data/models/upscale_models/"
ENV path_inpaint="/content/data/models/inpaint/"
ENV path_controlnet="/content/data/models/controlnet/"
ENV path_clip_vision="/content/data/models/clip_vision/"
ENV path_fooocus_expansion="/content/data/models/prompt_expansion/fooocus_expansion/"
ENV path_outputs="/content/app/outputs/"

RUN apt-get update -y && \
	apt-get install -y curl libgl1 libglib2.0-0 python3-pip python-is-python3 git && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY  requirements_versions.txt /tmp/
RUN pip install --no-cache-dir  -r /tmp/requirements_versions.txt && \
	rm -f  /tmp/requirements_versions.txt
RUN pip install lmdb
##RUN pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2 torchtext==0.15.2+cpu torchdata==0.6.1 --index-url https://download.pytorch.org/whl/cu118
RUN apt update 
##RUN pip install --no-cache-dir xformers==0.0.23 --no-dependencies
RUN curl -fsL -o /usr/local/lib/python3.10/dist-packages/gradio/frpc_linux_amd64_v0.2 https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64 && \
	chmod +x /usr/local/lib/python3.10/dist-packages/gradio/frpc_linux_amd64_v0.2

RUN pip install xformers --upgrade --force-reinstall --extra-index-url https://download.pytorch.org/whl/cu121
RUN pip install "numpy>=1.18.5,<1.26.0"

RUN adduser --disabled-password --gecos '' user && \
	mkdir -p /content/app /content/data

COPY entrypoint.sh /content/
RUN chown -R user:user /content
RUN chmod +x /content/entrypoint.sh


WORKDIR /content
USER user
EXPOSE 7865
ENV HOST 0.0.0.0

RUN git clone https://github.com/lllyasviel/Fooocus /content/app
RUN mv /content/app/models /content/app/models.org

CMD [ "sh", "-c", "/content/entrypoint.sh ${CMDARGS}" ]
