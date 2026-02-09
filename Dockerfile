# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj and restore
COPY AuthService.csproj ./
RUN dotnet restore AuthService.csproj

# Copy everything else
COPY . ./

# Publish project (IMPORTANT: publish csproj, not solution)
RUN dotnet publish AuthService.csproj -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/out .

ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE 8080

ENTRYPOINT ["dotnet", "AuthService.dll"]
