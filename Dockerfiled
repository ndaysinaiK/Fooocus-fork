FROM nvidia/cuda:12.3.1-base-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive
ENV CMDARGS --listen

WORKDIR /content
ENV PORT 7865
ENV HOST 0.0.0.0

RUN apt-get update -y && \
	apt-get install -y curl libgl1 libglib2.0-0 python3-pip python-is-python3 git && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY requirements_docker.txt requirements_versions.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements_docker.txt -r /tmp/requirements_versions.txt && \
	rm -f /tmp/requirements_docker.txt /tmp/requirements_versions.txt
RUN pip install --no-cache-dir xformers==0.0.23 --no-dependencies
RUN curl -fsL -o /usr/local/lib/python3.10/dist-packages/gradio/frpc_linux_amd64_v0.2 https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64 && \
	chmod +x /usr/local/lib/python3.10/dist-packages/gradio/frpc_linux_amd64_v0.2

RUN adduser --disabled-password --gecos '' user && \
	mkdir -p /content/app /content/data

COPY entrypoint.sh /content/
RUN chown -R user:user /content

USER user

RUN git clone https://github.com/lllyasviel/Fooocus /content/app
# Set environment variables
ENV CMDARGS="--listen" \
	DATADIR="/content/data" \
	config_path="/content/data/config.txt" \
	config_example_path="/content/data/config_modification_tutorial.txt" \
	path_checkpoints="/content/data/models/checkpoints/" \
	path_loras="/content/data/models/loras/" \
	path_embeddings="/content/data/models/embeddings/" \
	path_vae_approx="/content/data/models/vae_approx/" \
	path_upscale_models="/content/data/models/upscale_models/" \
	path_inpaint="/content/data/models/inpaint/" \
	path_controlnet="/content/data/models/controlnet/" \
	path_clip_vision="/content/data/models/clip_vision/" \
	path_fooocus_expansion="/content/data/models/prompt_expansion/fooocus_expansion/" \
	path_outputs="/content/app/outputs/"

# Expose ports
EXPOSE 7865

RUN mv /content/app/models /content/app/models.org

CMD [ "sh", "-c", "/content/app/entrypoint.sh ${CMDARGS}" ]
