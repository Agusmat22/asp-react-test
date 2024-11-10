# Usa la imagen de .NET SDK 8.0 para construir y ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copia los archivos de la solución y los archivos .csproj del proyecto del servidor
COPY *.sln ./
COPY crud-productos.Server/*.csproj ./crud-productos.Server/

# Restaura las dependencias del proyecto
RUN dotnet restore crud-productos.Server

# Copia todo el resto de los archivos del proyecto al contenedor
COPY . .

# Publica el proyecto en modo Release
RUN dotnet publish crud-productos.Server -c Release -o /app/out

# Usa una imagen de runtime de .NET 8.0 para reducir el tamaño del contenedor final
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expone el puerto que usa la aplicación
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

# Ejecuta la aplicación
ENTRYPOINT ["dotnet", "crud-productos.Server.dll"]
