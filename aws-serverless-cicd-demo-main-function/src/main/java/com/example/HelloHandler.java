package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class HelloHandler implements RequestHandler<Object,HelloResponse> {

  public final static String RESPONSE = "hello - v1";

  @Override
  public HelloResponse handleRequest(Object helloRequest, Context context) {
    log.info(RESPONSE);
    return new HelloResponse(RESPONSE);
  }
}
