FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

COPY ["EP.Connect.AP.Users.API/EP.Connect.AP.Users.API.csproj", "EP.Connect.AP.Users.API/"]

RUN dotnet restore "EP.Connect.AP.Users.API/EP.Connect.AP.Users.API.csproj" 
COPY . .
WORKDIR "/src/EP.Connect.AP.Users.API"
RUN dotnet build "EP.Connect.AP.Users.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EP.Connect.AP.Users.API.csproj" -c Release -o /app/publish

FROM base AS final

WORKDIR /app
COPY --from=publish /app/publish .

RUN ["apt-get", "update"]
RUN ["apt-get", "-y", "install", "vim"]

ENTRYPOINT ["dotnet", "EP.Connect.AP.Users.API.dll"]
