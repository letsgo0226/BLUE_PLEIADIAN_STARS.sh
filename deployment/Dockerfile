FROM python:3.12-alpine
WORKDIR /app
COPY solver.py verifier.py /app/
COPY deployment/run_forever.sh /app/run_forever.sh
COPY deployment/healthcheck.py /app/healthcheck.py
RUN chmod +x /app/run_forever.sh
ENV S=1 N=16 INTERVAL=1 DATA_DIR=/data
VOLUME ["/data"]
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["python3","/app/healthcheck.py","/data/state.json"]
CMD ["/app/run_forever.sh"]
