FROM rocker/shiny

RUN install2.r shinyWidgets lubridate remotes
RUN installGithub.r -u FALSE dreamRs/particlesjs

RUN mkdir /app
COPY *.R /app/

CMD ["R", "-e", "shiny::runApp('/app')"]
