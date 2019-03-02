import http from "k6/http";
import { sleep } from "k6";

export let options = {
  vus: 10,
  duration: "5m"
};

const services = [
  "dotnetcore",
  "java",
  "python",
  "node"
]

export default function() {

  services.forEach(service => {
    http.get(`http://${service}/`);
    services.forEach(serviceCall => {
      if(service === serviceCall) {
        return;
      }
      http.get(`http://${service}/${serviceCall}`);
    });
  });  
};