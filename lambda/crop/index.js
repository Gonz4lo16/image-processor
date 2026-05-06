exports.handler = async (event) => {
  try {
    console.log("SQS Event received:", JSON.stringify(event));

    for (const record of event.Records) {
      const message = JSON.parse(record.body);

      console.log("Processing image:", message);

      // Simulación de procesamiento (crop)
      const result = {
        originalKey: message.key,
        status: "processed",
        timestamp: new Date().toISOString()
      };

      console.log("Result:", result);
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Processed successfully"
      })
    };

  } catch (error) {
    console.log(error);

    throw error;
  }
};