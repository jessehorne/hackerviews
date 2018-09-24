document.body.onload = (function() {
	hv = {};

	hv.list = {};

	hv.list.list = document.getElementById("hv-list");

	hv.list.page = 1;
	hv.list.filter = "new";

	hv.times = {}

	hv.times["home"] = 10; // Updates the home page every 10 seconds

	hv.comments = {};

	hv.comments.update = function(post_id) {
		var comments = document.getElementById("hv-comments");

		var path = "/post/comments/" + post_id;

		var req = new XMLHttpRequest();

		req.open("GET", "http://localhost:3000" + path, true);

		req.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				var comments = JSON.parse(req.responseText);

				comments.forEach(function(item) {
					var existing = document.getElementById("hv_comment_" + item["id"]);

					if (!existing) {
						hv.comments.create(item);
						console.log("created!")
					}
				});
			}
		};

		req.send();
	}

	hv.comments.create = function(comment) {
		var comments = document.getElementById("hv-comments");
		var list_item = document.createElement("li");
		list_item.className = "hv-comment";
		list_item.id = "hv_comment_" + comment["id"];

		var author = document.createElement("a");
		author.href = "/user/" + comment["username"];
		author.className = "hv-comment-author";
		author.innerHTML = comment["username"];
		list_item.appendChild(author);

		var text = document.createElement("div");
		text.className = "hv-comment-text";
		text.innerHTML = comment["text"];
		list_item.appendChild(text);

		comments.appendChild(list_item);
	}

	hv.comments.clear = function() {
		var comments = document.getElementById("hv-comments");
		comments.innerHTML = "";
	}

	hv.list.create_or_update = function(post) {
		var existing = document.getElementById("hv_post_" + post["id"]);

		var list_item = document.createElement("li");

		list_item.id = "hv_post_" + post["id"];

		var updown_div = document.createElement("div");
		updown_div.className = "hv-updown";

		var up_img = document.createElement("img");
		up_img.src = "/up.png";
		updown_div.appendChild(up_img);

		var down_img = document.createElement("img");
		down_img.src = "/down.png";
		updown_div.appendChild(down_img);

		list_item.appendChild(updown_div);


		var list_title = document.createElement("a");
		list_title.className = "hv-list-title";
		list_title.href = post["url"];
		list_title.innerHTML = post["title"];
		list_item.appendChild(list_title);

		var stats_header = document.createElement("h2");

		// Calculate Age
		var created_at = new Date(post["created_at"]);
		var now = new Date();
		var res = Math.floor(now-created_at) / 1000;
		var days = Math.floor(res / 86400);
		var hours = Math.floor(res / 3600) % 24;
		var minutes = Math.floor(res / 60) % 60;
		var seconds = Math.floor(res % 60);
		var age_text = `${days}d - ${hours}h - ${minutes}m - ${seconds}s`;


		var ups_downs_text = `Ups/Downs: <b>${post['ups']}</b>/<b>${post['downs']}</b> |`;
		var views_clicks_text = `Views/Clicks: <b>${post['views']}</b>/<b>${post['clicks']}</b> |`;
		var author_text = `Author: <a href="/user/${post['username']}" class='hv-list-author'>${post['username']}</a> |`;
		var age_text = `Age: <b class='hv-post-age'>${age_text}</b> |`;
		var comments_text = `<a href='/post/comments/${post['id']}'><b>000</b> comments</a>`;
		var all_text = ups_downs_text + views_clicks_text + author_text + age_text + comments_text;
		stats_header.innerHTML = all_text;
		list_item.appendChild(stats_header);

		if (existing) {
			existing.innerHTML = list_item.innerHTML;
		} else {
			hv.list.list.appendChild(list_item);
		}
	}

	hv.gets = {}

	hv.gets["home"] = function() {
		if (window.location.pathname == "/") {
			var path = "/post/" + hv.list.filter + "/" + hv.list.page;

			var req = new XMLHttpRequest();

			req.open("GET", "http://localhost:3000" + path, true);

			req.onreadystatechange = function() {
				if (this.readyState == 4 && this.status == 200) {
					var posts = JSON.parse(req.responseText);

					posts.forEach(function(item) {
						hv.list.create_or_update(item);
					});
				}
			};

			req.send();
		}
	}


	hv.navs = {}

	hv.navs["new"] = document.getElementById("nav-new");
	hv.navs["top"] = document.getElementById("nav-top");
	hv.navs["show"] = document.getElementById("nav-show");
	hv.navs["ask"] = document.getElementById("nav-ask");
	hv.navs["jobs"] = document.getElementById("nav-jobs");

	// Handle nav onclick functionality
	hv.navs["new"].onclick = function() {
		hv.list.filter = "new";
		hv.update();
	}

	hv.navs["top"].onclick = function() {
		hv.list.filter = "top";
		hv.update();
	}

	hv.navs["show"].onclick = function() {
		hv.list.filter = "show";
		hv.update();
	}

	hv.navs["ask"].onclick = function() {
		hv.list.filter = "ask";
		hv.update();
	}

	hv.navs["jobs"].onclick = function() {
		hv.list.filter = "jobs";
		hv.update();
	}

	hv.intervals = {}

	// Calls gets["home"] every five seconds which updates the home page list
	hv.update = function() {
		if ("home" in hv.intervals) {
			clearInterval(hv.intervals["home"]);
		}

		hv.list.list.innerHTML = "";

		hv.gets["home"]()
		hv.intervals["home"] = setInterval(hv.gets["home"], hv.times["home"]*1000);
	}

	if (window.location.pathname == "/") {
		hv.update();
	}

	console.log("hv.js loaded!");
});
