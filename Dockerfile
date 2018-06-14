FROM nginx:1.13.5-alpine

COPY ./build /usr/share/nginx/html
ENV NODE_ENV production

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
