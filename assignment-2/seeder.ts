import mysql from "mysql2/promise";
import { config } from "dotenv";
import { faker } from "@faker-js/faker";
import { v4 as uuidv4 } from "uuid";

config();

const createConnection = async () => {
  return mysql.createConnection({
    host: process.env.HOST,
    user: process.env.DB_USER,
    password: process.env.PASSWORD,
    database: process.env.DATABASE,
    port: parseInt(process.env.PORT || "3306"),
  });
};

const createTables = async (connection: mysql.Connection) => {
  const userTable = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      status ENUM('active', 'inactive') NOT NULL,
      created_at TIMESTAMP NOT NULL
    );
  `;

  const profileTable = `
    CREATE TABLE IF NOT EXISTS profiles (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      first_name VARCHAR(255),
      last_name VARCHAR(255),
      bio VARCHAR(1000),
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  `;

  const postTable = `
    CREATE TABLE IF NOT EXISTS posts (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      content VARCHAR(5000) NOT NULL,
      created_at TIMESTAMP NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  `;

  const likeTable = `
    CREATE TABLE IF NOT EXISTS likes (
      id INT AUTO_INCREMENT PRIMARY KEY,
      post_id INT,
      user_id INT,
      liked_at TIMESTAMP NOT NULL,
      FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  `;

  await connection.execute(userTable);
  await connection.execute(profileTable);
  await connection.execute(postTable);
  await connection.execute(likeTable);
};

const randomInt = (min: number, max: number) => {
  return Math.floor(Math.random() * (max - min + 1) + min);
};

const isValidDate = (date: Date) => {
  const hours = date.getUTCHours();
  return !(hours >= 2 && hours < 4); // Skip problematic 2 AM to 4 AM window
};

const randomDate = (start: Date, end: Date) => {
  return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
};

const getRandomTimestamp = () => {
  const startDate = new Date("2021-01-01T00:00:00Z");
  const endDate = new Date("2024-12-31T23:59:59Z");
  let randomDateValue;

  do {
    randomDateValue = randomDate(startDate, endDate);
  } while (!isValidDate(randomDateValue));

  return randomDateValue.toISOString().slice(0, 19).replace("T", " ");
};

const insertData = async (connection: mysql.Connection) => {
  console.log("Inserting into users...");

  const batchSize = 1000;
  const userInsertQuery = `INSERT INTO users (username, email, status, created_at) VALUES (?, ?, ?, ?)`;
  const users: [string, string, string, string][] = [];

  for (let i = 0; i < 100000; i++) {
    users.push([
      faker.internet.userName(),
      `${uuidv4().slice(9)}${faker.internet.email()}`,
      faker.helpers.arrayElement(["active", "inactive"]),
      getRandomTimestamp(),
    ]);
  }

  for (let i = 0; i < users.length; i += batchSize) {
    const userBatch = users.slice(i, i + batchSize);
    const values = userBatch.flat();
    const placeholders = userBatch.map(() => "(?, ?, ?, ?)").join(", ");
    await connection.query(userInsertQuery.replace("(?, ?, ?, ?)", placeholders), values);
  }

  console.log("Inserted users.");

  console.log("Inserting into profiles...");

  const profileInsertQuery = `INSERT INTO profiles (user_id, first_name, last_name, bio) VALUES (?, ?, ?, ?)`;
  const profiles: [number, string, string, string][] = [];
  for (let i = 1; i <= 100000; i++) {
    profiles.push([i, faker.person.firstName(), faker.person.lastName(), faker.lorem.sentence()]);
  }

  for (let i = 0; i < profiles.length; i += batchSize) {
    const profileBatch = profiles.slice(i, i + batchSize);
    const values = profileBatch.flat();
    const placeholders = profileBatch.map(() => "(?, ?, ?, ?)").join(", ");
    await connection.query(profileInsertQuery.replace("(?, ?, ?, ?)", placeholders), values);
  }

  console.log("Inserted profiles.");

  console.log("Inserting into posts...");

  const postInsertQuery = `INSERT INTO posts (user_id, content, created_at) VALUES (?, ?, ?)`;
  const posts: [number, string, string][] = [];
  for (let i = 0; i < 1000000; i++) {
    posts.push([randomInt(1, 100000), faker.lorem.paragraph(), getRandomTimestamp()]);
  }

  for (let i = 0; i < posts.length; i += batchSize) {
    const postBatch = posts.slice(i, i + batchSize);
    const values = postBatch.flat();
    const placeholders = postBatch.map(() => "(?, ?, ?)").join(", ");
    await connection.query(postInsertQuery.replace("(?, ?, ?)", placeholders), values);
  }

  console.log("Inserted posts.");

  console.log("Inserting into likes...");

  const likeInsertQuery = `INSERT INTO likes (post_id, user_id, liked_at) VALUES (?, ?, ?)`;
  const likes: [number, number, string][] = [];
  for (let i = 0; i < 5000000; i++) {
    likes.push([randomInt(1, 1000000), randomInt(1, 100000), getRandomTimestamp()]);
  }

  for (let i = 0; i < likes.length; i += batchSize) {
    const likeBatch = likes.slice(i, i + batchSize);
    const values = likeBatch.flat();
    const placeholders = likeBatch.map(() => "(?, ?, ?)").join(", ");
    await connection.query(likeInsertQuery.replace("(?, ?, ?)", placeholders), values);
  }

  console.log("Inserted likes.");
};

const main = async () => {
  const connection = await createConnection();

  try {
    await createTables(connection);
    await insertData(connection);
    console.log("Data seeding and index creation completed successfully.");
  } catch (error) {
    console.error("Error during seeding:", error);
  } finally {
    await connection.end();
  }
};

main();
