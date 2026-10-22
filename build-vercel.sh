#!/bin/bash
set -e

# 1. Clean previous build directory structures
rm -rf .vercel/output
mkdir -p .vercel/output/services/springboot-app

# 2. Compile the Spring Boot App (assumes Maven, replace with gradle if needed)
./mvnw clean package -DskipTests

# 3. Copy the generated JAR into the target service directory
cp target/*.jar .vercel/output/services/springboot-app/app.jar

# 4. Generate the Service metadata descriptor.json
# Tells Vercel how to launch the Java execution layer
cat <<EOF > .vercel/output/services/springboot-app/descriptor.json
{
  "runtime": "provided",
  "entrypoint": "app.jar",
  "command": "java -jar app.jar"
}
EOF

# 5. Generate the top-level Vercel config.json
# Binds the API routing layout to target your containerized service
cat <<EOF > .vercel/output/config.json
{
  "version": 3,
  "services": [
    {
      "name": "springboot-app",
      "root": "services/springboot-app/"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "springboot-app"
    }
  ]
}
EOF

echo "✓ Vercel Build Output API layout structured successfully."