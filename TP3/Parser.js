/**
 * Parse
 * @constructor
 * @param scene - Reference to MyScene object
 */
class Parser extends CGFobject {
	constructor(scene) {
		super(scene);
		this.scene = scene;
		this.board = '[[empty,empty,empty,empty,empty],[empty,white,white,white,empty],[empty,empty,empty,empty,empty],[empty,black,black,black,empty],[empty,empty,empty,empty,empty]]';
		this.previousBoard = '[[empty,empty,empty,empty,empty],[empty,white,white,white,empty],[empty,empty,empty,empty,empty],[empty,black,black,black,empty],[empty,empty,empty,empty,empty]]';
		this.data;
		this.gameOver;
		this.valid;
		this.nudge;
	}

	makeMove(lastRow, lastCol, newRow, newCol, player, other) {
		var req = 'move(' + lastRow + ',' + lastCol + ',' + newRow + ',' + newCol + ',' + player + ',' + other + ',' + this.board + ',' + this.previousBoard + ')';
		console.log(this.board);
		this.makeRequest(req);
		this.answer();
	}

	makeMoveAi(color, other) {
		var req = 'ai(' + color + ',' + other + ',' + this.board + ',' + this.PreviousBoard + ')';
		this.makeRequest(req);
		var moves = this.answerAi();
		return moves;
	}

	answerAi() {
		let ans = this.data;
		console.log(ans);
		let i = 1, vec = [];

		let currentRow1 = ans.substring(i, i + 1);
		vec.push(currentRow1);
		i += 2;
		let currentColumn1 = ans.substring(i, i + 1);
		vec.push(currentColumn1);
		i += 2;
		let newRow1 = ans.substring(i, i + 1);
		vec.push(newRow1);
		i += 2;
		let newColumn1 = ans.substring(i, i + 1);
		vec.push(newColumn1);
		i += 2;
		let currentRow2 = ans.substring(i, i + 1);
		vec.push(currentRow2);
		i += 2;
		let currentColumn2 = ans.substring(i, i + 1);
		vec.push(currentColumn2);
		i += 2;
		let newRow2 = ans.substring(i, i + 1);
		vec.push(newRow2);
		i += 2;
		let newColumn2 = ans.substring(i, i + 1);
		vec.push(newColumn2);
		i += 2;
		this.gameOver = ans.substring(i, i + 1);
		this.previousBoard = this.board;
		let board = ans.match(/\[{2}.*\]{2}/)[0];
		this.board = board.substring(0, board.length - 1);

		return vec;
	}

	answer() {
		var ans = this.data;
		console.log("asss");
		console.log(ans);

		var valid = ans.match(/\[.{2,3}\,/)[0];
		console.log(valid.length - 1);
		this.valid = valid.substring(1, valid.length - 1);
		var nudge = ans.match(/\,.{2,3}\,/)[0];
		this.nudge = nudge.substring(1, nudge.length - 1);

		if (this.valid == "yes") {
			this.previousBoard = this.board;
			var board = ans.match(/\[{2}.*\]{2}/)[0];
			this.board = board.substring(0, board.length - 1);

			var gameOver = ans.match(/\,.{1}\,\[{2}/)[0];
			this.gameOver = gameOver.substring(1, 2);
		}
	}

	getPrologRequest(requestString, onSuccess, onError, port) {
		var requestPort = port || 8081
		var request = new XMLHttpRequest();
		request.open('GET', 'http://localhost:' + requestPort + '/' + requestString, false);

		request.onload = onSuccess || function (data) { console.log("Request successful. Reply: " + data.target.response); };
		request.onerror = onError || function () { console.log("Error waiting for response"); };

		request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
		request.send();
	}

	makeRequest(command) {
		// Get Parameter Values
		console.log("Req " + command);
		// Make Request
		this.getPrologRequest(command, this.handleReply.bind(this));
	}

	//Handle the Reply
	handleReply(data) {
		this.data = data.target.response;
		console.log("kkkk");
		console.log(this.data);
	}

	/**
	 * @method updateTexCoords
	 * Updates the list of texture coordinates of the rectangle
	 * @param {Array} coords - Array of texture coordinates
	 */
	updateTexCoords(coords) {
		this.updateTexCoordsGLBuffers();
	}

	updateLengthT(l) {
	}

	updateLengthS(l) {
	}
}