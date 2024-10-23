import mysql from "mysql2/promise";
import { config } from "dotenv";
import { faker } from "@faker-js/faker";
import { v4 as uuidv4 } from "uuid";
import cliProgress from "cli-progress";

config();

const BATCH_SIZE = 1000;
const USERS_COUNT = 10000;
const POSTS_COUNT = 50000;
const COMMENTS_COUNT = 100000;
const POST_LIKES_COUNT = 500000;
const COMMENT_LIKES_COUNT = 1000000;

const createConnection = async () => {
  return mysql.createConnection({
    host: process.env.HOST,
    user: process.env.DB_USER,
    password: process.env.PASSWORD,
    database: process.env.DATABASE,
    port: parseInt(process.env.PORT || "3306"),
  });
};

const randomInt = (min, max) => {
  return Math.floor(Math.random() * (max - min + 1) + min);
};

const isValidDate = (date) => {
  const hours = date.getUTCHours();
  return !(hours >= 2 && hours < 4);
};

const randomDate = (start, end) => {
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

const insertBatchData = async (connection, query, data, batchSize, progressBar) => {
  for (let i = 0; i < data.length; i += batchSize) {
    const batch = data.slice(i, i + batchSize);
    const values = batch.flat();
    const placeholders = batch.map(() => `(${query.placeholders})`).join(", ");
    await connection.query(query.statement.replace(`(${query.placeholders})`, placeholders), values);
    progressBar.increment(batchSize);
  }
};

const generateData = (count, generator) => {
  const data: any[] = [];
  for (let i = 0; i < count; i++) {
    data.push(generator(i));
  }
  return data;
};

const insertData = async (connection) => {
  console.log("Inserting into users...");
  const userInsertQuery = {
    statement: `INSERT INTO User (username, email, password_hash, created_at) VALUES (?, ?, ?, ?)`,
    placeholders: "?, ?, ?, ?",
  };
  const users = generateData(USERS_COUNT, () => [
    faker.internet.userName(),
    `${uuidv4().slice(9)}${faker.internet.email()}`,
    faker.internet.password(),
    getRandomTimestamp(),
  ]);
  const userProgressBar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic);
  userProgressBar.start(USERS_COUNT, 0);
  await insertBatchData(connection, userInsertQuery, users, BATCH_SIZE, userProgressBar);
  userProgressBar.stop();
  console.log("Inserted users.");

  console.log("Inserting into profiles...");
  const profileInsertQuery = {
    statement: `INSERT INTO Profile (user_id, first_name, last_name, phone_number, address) VALUES (?, ?, ?, ?, ?)`,
    placeholders: "?, ?, ?, ?, ?",
  };
  const profiles = generateData(USERS_COUNT, (i) => [
    i + 1,
    faker.person.firstName(),
    faker.person.lastName(),
    faker.phone.number({ style: "national" }),
    faker.location.streetAddress(),
  ]);
  const profileProgressBar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic);
  profileProgressBar.start(USERS_COUNT, 0);
  await insertBatchData(connection, profileInsertQuery, profiles, BATCH_SIZE, profileProgressBar);
  profileProgressBar.stop();
  console.log("Inserted profiles.");

  console.log("Inserting into posts...");
  const postInsertQuery = {
    statement: `INSERT INTO Posts (user_id, title, text, media_url, created_at) VALUES (?, ?, ?, ?, ?)`,
    placeholders: "?, ?, ?, ?, ?",
  };
  const posts = generateData(POSTS_COUNT, () => [
    randomInt(1, USERS_COUNT),
    faker.lorem.sentence(),
    faker.lorem.paragraph(),
    faker.internet.url(),
    getRandomTimestamp(),
  ]);
  const postProgressBar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic);
  postProgressBar.start(POSTS_COUNT, 0);
  await insertBatchData(connection, postInsertQuery, posts, BATCH_SIZE, postProgressBar);
  postProgressBar.stop();
  console.log("Inserted posts.");

  console.log("Inserting into comments...");
  const commentInsertQuery = {
    statement: `INSERT INTO Comments (post_id, user_id, text, created_at) VALUES (?, ?, ?, ?)`,
    placeholders: "?, ?, ?, ?",
  };
  const comments = generateData(COMMENTS_COUNT, () => [
    randomInt(1, POSTS_COUNT),
    randomInt(1, USERS_COUNT),
    faker.lorem.sentence(),
    getRandomTimestamp(),
  ]);
  const commentProgressBar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic);
  commentProgressBar.start(COMMENTS_COUNT, 0);
  await insertBatchData(connection, commentInsertQuery, comments, BATCH_SIZE, commentProgressBar);
  commentProgressBar.stop();
  console.log("Inserted comments.");

  console.log("Inserting into post likes...");
  const postLikeInsertQuery = {
    statement: `INSERT INTO PostLikes (post_id, user_id, created_at) VALUES (?, ?, ?)`,
    placeholders: "?, ?, ?",
  };
  const postLikes = generateData(POST_LIKES_COUNT, () => [
    randomInt(1, POSTS_COUNT),
    randomInt(1, USERS_COUNT),
    getRandomTimestamp(),
  ]);
  const postLikeProgressBar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic);
  postLikeProgressBar.start(POST_LIKES_COUNT, 0);
  await insertBatchData(connection, postLikeInsertQuery, postLikes, BATCH_SIZE, postLikeProgressBar);
  postLikeProgressBar.stop();
  console.log("Inserted post likes.");

  console.log("Inserting into comment likes...");
  const commentLikeInsertQuery = {
    statement: `INSERT INTO CommentLikes (comment_id, user_id, created_at) VALUES (?, ?, ?)`,
    placeholders: "?, ?, ?",
  };
  const commentLikes = generateData(COMMENT_LIKES_COUNT, () => [
    randomInt(1, COMMENTS_COUNT),
    randomInt(1, USERS_COUNT),
    getRandomTimestamp(),
  ]);
  const commentLikeProgressBar = new cliProgress.SingleBar({}, cliProgress.Presets.shades_classic);
  commentLikeProgressBar.start(COMMENT_LIKES_COUNT, 0);
  await insertBatchData(connection, commentLikeInsertQuery, commentLikes, BATCH_SIZE, commentLikeProgressBar);
  commentLikeProgressBar.stop();
  console.log("Inserted comment likes.");
};

const main = async () => {
  const connection = await createConnection();

  try {
    await insertData(connection);
    console.log("Data seeding completed successfully.");
  } catch (error) {
    console.error("Error during seeding:", error);
  } finally {
    await connection.end();
  }
};

main();
