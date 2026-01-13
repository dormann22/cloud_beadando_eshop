FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY global.json .
COPY Directory.Packages.props .

COPY *.props . 

COPY src/Web/*.csproj ./src/Web/
COPY src/Infrastructure/*.csproj ./src/Infrastructure/
COPY src/ApplicationCore/*.csproj ./src/ApplicationCore/
COPY src/BlazorShared/*.csproj ./src/BlazorShared/
COPY src/BlazorAdmin/*.csproj ./src/BlazorAdmin/

RUN dotnet restore src/Web/Web.csproj

COPY . .

WORKDIR /app/src/Web
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
EXPOSE 8080
ENTRYPOINT ["dotnet", "Web.dll"]
