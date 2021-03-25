package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.lambda.LambdaClient;
import software.amazon.awssdk.services.lambda.model.InvokeRequest;

import java.util.Objects;

@Slf4j
class SanityCheckIT {

  private final Region region = Region.EU_WEST_3;
  private final String applicationNameEnvVarName = "APPLICATION_NAME";
  private String lambdaFunctionName;

  @Test
  void bodyHasCorrectVersion() {
    // given
    lambdaFunctionName = Objects.requireNonNull(System.getenv(applicationNameEnvVarName));
    log.info("lambdaFunctionName: {}", lambdaFunctionName);
    HelloResponse expectedResponse = new HelloResponse(HelloHandler.RESPONSE);

    // when
    HelloResponse actualResponse = invokeFunction();

    // then
    Assertions.assertThat(actualResponse)
        .usingRecursiveComparison()
        .isEqualTo(expectedResponse);
  }

  @SneakyThrows
  public HelloResponse invokeFunction() {
    String functionName = lambdaFunctionName;
    try (LambdaClient awsLambda = LambdaClient.builder()
        .region(region)
        .build()) {

      //Setup an InvokeRequest
      InvokeRequest request = InvokeRequest.builder()
          .functionName(functionName)
          .payload(SdkBytes.fromUtf8String("{}"))
          .build();

      //Invoke the Lambda function
      String responseString = awsLambda.invoke(request).payload().asUtf8String();
      return new ObjectMapper().readValue(responseString, HelloResponse.class);
    }
  }
}
