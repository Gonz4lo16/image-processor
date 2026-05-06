const AWS = require("aws-sdk");
const s3 = new AWS.S3();

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body || "{}");

    if (!body.image) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Image is required" })
      };
    }

    const buffer = Buffer.from(body.image, "base64");

    const key = `uploads/${Date.now()}.jpg`;

    await s3.putObject({
      Bucket: process.env.S3_BUCKET,
      Key: key,
      Body: buffer,
      ContentType: "image/jpeg"
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Upload successful",
        key
      })
    };

  } catch (error) {
    console.log(error);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal server error"
      })
    };
  }
};