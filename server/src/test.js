
import { poolConnect } from "./config/connectDB.js";


poolConnect();

import { load, add, del, patch, getTables } from "./utils/mssql.js";
const role = {
  login: "sa",
  pass: "password123@",
  database: "master",
};
load("SELECT * FROM NHANVIEN", role);

////
export default function test () {
  console.log("test function");
};
