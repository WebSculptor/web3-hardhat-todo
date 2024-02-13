// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract TodoContract {
    // Created a struct to represent a todo item
    struct TodoStruct {
        address user;
        string title;
        string content;
        bool isCompleted;
    }

    // Array to store all todo items
    TodoStruct[] public todos;

    // Adding a new todo item to the todos array
    function addTodo(string memory _title, string memory _content) external {
        // Creating a new todo struct with the sender's address, title, content, and default isCompleted status
        TodoStruct memory newTodo = TodoStruct({
            user: msg.sender,
            title: _title,
            content: _content,
            isCompleted: false
        });
        // Push the new todo to the array of todos
        todos.push(newTodo);
    }

    // Function to retrieve all todo items associated with the caller's address
    function getUserTodos()
        external
        view
        returns (string[] memory, string[] memory, bool[] memory)
    {
        uint256 length = todos.length;
        // Initialize arrays to store titles, contents, and completion statuses of todos
        string[] memory titles = new string[](length);
        string[] memory contents = new string[](length);
        bool[] memory isCompletedArray = new bool[](length);

        // Iterate through all todos
        for (uint256 i = 0; i < length; i++) {
            // Check if the todo belongs to the caller's address
            if (todos[i].user == msg.sender) {
                // If it does, add its title, content, and completion status to the respective arrays
                titles[i] = todos[i].title;
                contents[i] = todos[i].content;
                isCompletedArray[i] = todos[i].isCompleted;
            }
        }

        // Return the arrays containing titles, contents, and completion statuses of todos associated with the caller's address
        return (titles, contents, isCompletedArray);
    }

    // Function to mark a todo item as completed or incomplete
    function toggleIsCompleted(uint index) external {
        // Ensure the provided index is within the bounds of the todos array
        require(index < todos.length, "NOTE DOES NOT EXIST");

        // Toggle the completion status of the todo at the specified index
        todos[index].isCompleted = !todos[index].isCompleted;
    }

    // Function to delete a todo item by index
    function deleteTodoByIndex(uint index) external {
        // Ensure the provided index is within the bounds of the todos array
        require(index < todos.length, "NOTE DOES NOT EXIST");

        // Delete the todo item at the specified index
        delete todos[index];
    }

    // Function to update the title and content of a todo item by index
    function updateTodoByIndex(
        uint index,
        string memory _title,
        string memory _content
    ) external {
        // Ensure the provided index is within the bounds of the todos array
        require(index < todos.length, "NOTE DOES NOT EXIST");

        // Update the title and content of the todo item at the specified index
        todos[index].title = _title;
        todos[index].content = _content;
    }
}
