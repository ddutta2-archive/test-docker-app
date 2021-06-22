#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["testdockerapp/testdockerapp.csproj", "testdockerapp/"]
RUN dotnet restore "testdockerapp/testdockerapp.csproj"
COPY . .
WORKDIR "/src/testdockerapp"
RUN dotnet build "testdockerapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "testdockerapp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "testdockerapp.dll"]