#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Use aspnet core runtime as base
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
ENV ASPNETCORE_URLS http://+:5000
EXPOSE 5000

# Add sdk as a build layer
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build

# Add source code and build the app
WORKDIR /src
COPY ["src/TailspinToysWeb/TailspinToysWeb.csproj", "src/TailspinToysWeb/"]
RUN dotnet restore "src/TailspinToysWeb/TailspinToysWeb.csproj"
COPY . .
WORKDIR "/src/src/TailspinToysWeb"
RUN dotnet build "TailspinToysWeb.csproj" -c Release -o /app/build

# publish the app
FROM build AS publish
RUN dotnet publish "TailspinToysWeb.csproj" -c Release -o /app/publish

# run the app
FROM base AS final
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TailspinToysWeb.dll"]