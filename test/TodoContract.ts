import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("TodoContract Deployment", function () {
  async function deployTodoContract() {
    const TodoContract = await ethers.getContractFactory("TodoContract");
    const {
      addTodo,
      updateTodoByIndex,
      getUserTodos,
      deleteTodoByIndex,
      toggleIsCompleted,
    } = await TodoContract.deploy();

    return {
      TodoContract,
      addTodo,
      updateTodoByIndex,
      getUserTodos,
      deleteTodoByIndex,
      toggleIsCompleted,
    };
  }

  describe("Testing the todo contract", () => {
    it("should add a new todo", async () => {
      const { addTodo, getUserTodos } = await loadFixture(deployTodoContract);
      await addTodo("Title", "Content");

      const todos = await getUserTodos();

      expect(todos[0]).to.deep.equal(["Title"]);
      expect(todos[1]).to.deep.equal(["Content"]);
      expect(todos[2]).to.deep.equal([false]);
    });

    it("should update a todo by its ID", async () => {
      const { addTodo, updateTodoByIndex, getUserTodos } = await loadFixture(
        deployTodoContract
      );

      await addTodo("Title", "Content");
      await updateTodoByIndex(0, "New Title", "New Content");

      const todos = await getUserTodos();

      expect(todos[0]).to.deep.equal(["New Title"]);
      expect(todos[1]).to.deep.equal(["New Content"]);
      expect(todos[2]).to.deep.equal([false]);
    });

    it("should set isCompleted from false to true", async () => {
      const { addTodo, toggleIsCompleted, getUserTodos } = await loadFixture(
        deployTodoContract
      );

      await addTodo("Title", "Content");
      await toggleIsCompleted(0);

      const todos = await getUserTodos();

      expect(todos[2]).to.deep.equal([true]);
    });

    it("should delete a todo from the array", async () => {
      const { addTodo, deleteTodoByIndex, getUserTodos } = await loadFixture(
        deployTodoContract
      );

      await addTodo("Title", "Content");
      await deleteTodoByIndex(0);

      const todos = await getUserTodos();

      expect(todos[0].length).to.equal(0);
      expect(todos[1].length).to.equal(0);
      expect(todos[2].length).to.equal(0);
    });
  });
});
