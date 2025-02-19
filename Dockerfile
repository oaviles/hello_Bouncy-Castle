FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
WORKDIR /app

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["hello_Bouncy-Castle-Demo.csproj", "./"]
COPY ["Program.cs", "./"]
RUN dotnet restore "hello_Bouncy-Castle-Demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "hello_Bouncy-Castle-Demo.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "hello_Bouncy-Castle-Demo.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "hello_Bouncy-Castle-Demo.dll"]
