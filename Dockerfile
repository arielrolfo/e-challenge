FROM ruby

RUN mkdir /share
ADD ecl-license.rb /

ENTRYPOINT ["ruby", "ecl-license.rb"]
