# ICEfaces Auction Monitor

The "Auction Monitor" sample from ICEfaces (ICEsoft, Apache License 2.0): a live auction page that uses Ajax Push to send bids, countdowns and chat messages to every connected browser. It was one of the NeoLoad training applications. Source: `samples/compat/auctionMonitor` in the [svn2github/icefaces](https://github.com/svn2github/icefaces) mirror.

The Docker build compiles it with Maven against released ICEfaces 3.x libraries from Maven Central (`build.sh` tries a few version combinations), then runs it on Tomcat 9 + Java 8.

## Deploy on Render (free)

1. Sign in at https://render.com.
2. **New → Web Service → Public Git Repository**, paste `https://github.com/the-engineer-io/icefaces-auction-monitor` and click Connect.
3. Keep the detected **Docker** language, pick the **Free** instance type, and click **Deploy Web Service**.
4. When the deploy finishes, open `https://<your-service>.onrender.com/auctionMonitor/`.

The free instance sleeps after 15 minutes without traffic and takes a minute or two to wake up. Open the URL once before recording.

## Run locally

```
docker build -t auction-monitor .
docker run -p 8082:8080 auction-monitor
```

Then open http://localhost:8082/auctionMonitor/.

## Using it

No login: bid on items, and enter a nickname to join the chat. Open it in two browsers to watch updates being pushed between them.

For NeoLoad: the page keeps a long-polling ICEpush connection open and sends JSF/ICEfaces Ajax POSTs that carry `javax.faces.ViewState` and ICEfaces window/view ids, which change on every run and need correlating.
