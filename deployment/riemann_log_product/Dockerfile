FROM python:3.12-alpine
WORKDIR /app
COPY RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh /app/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh
COPY deployment/riemann_log_product/resident_loop.sh /app/resident_loop.sh
RUN chmod +x /app/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh /app/resident_loop.sh
ENV ROOT=/app DATA_DIR=/data INTERVAL=1
VOLUME ["/data"]
CMD ["/app/resident_loop.sh"]
