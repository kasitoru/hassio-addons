ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION
ARG TZ=Europe/Moscow

RUN apt update && apt install -y curl unzip xz-utils alsa-utils libgdiplus libicu76

# Install iSpy Agent DVR and FFmpeg
COPY downloads /agent/downloads
RUN set -eux; \
	case "$BUILD_ARCH" in \
    amd64) \
		AGENT_ZIP="Agent_Linux64_7_1_7_0.zip"; \
		FFMPEG_TAR="ffmpeg7-linuxx64.tar.xz" \
        ;; \
    aarch64) \
		AGENT_ZIP="Agent_LinuxARM64_7_1_7_0.zip"; \
		FFMPEG_TAR="ffmpeg7-linuxarm64.tar.xz" \
        ;; \
    esac; \
	unzip "/agent/downloads/$AGENT_ZIP" -d /agent; \
	mkdir -p /agent/ffmpeg7; \
	tar -xvf "/agent/downloads/$FFMPEG_TAR" --strip-components=1 -C "/agent/ffmpeg7"
RUN rm -rf /agent/downloads
COPY run.sh /agent/

# Modify permission for execution
RUN chmod +x /agent/Agent && \
  chmod +x /agent/agent-register.sh && \
  chmod +x /agent/agent-reset.sh && \
  chmod +x /agent/agent-reset-local-login.sh && \
  chmod +x /agent/run.sh

# Define default environment variables
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Fix a memory leak on encoded recording
ENV MALLOC_TRIM_THRESHOLD_=100000

# Main UI port
EXPOSE 8090

# STUN server port
EXPOSE 3478/udp

# TURN server UDP port range
EXPOSE 50000-50010/udp

VOLUME ["/data"]
CMD ["/agent/run.sh"]

LABEL \
  io.hass.type="addon" \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.arch="${BUILD_ARCH}"
