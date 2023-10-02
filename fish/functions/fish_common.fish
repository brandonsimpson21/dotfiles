

function docker_qdrant

	docker run -p 6333:6333 \
		-v $(pwd)/qdrant_storage:/qdrant/storage:z \
		qdrant/qdrant
end

function docker_surreal
	docker run --rm --pull always --name surrealdb-dev -p 5432:5432 surrealdb/surrealdb:latest start --log trace --user surrealdb --pass password memory
end

function docker_redis
 	docker run -d --name redis-dev -p 6379:6379 redis/redis-stack-server:latest
end

function docker_postgres
	docker run --name postgres-dev -p 8000:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_USER=postgres -d postgres
end

function rust_coverage
	
	set CARGO_INCREMENTAL 0
	set RUSTFLAGS "-Zprofile -Ccodegen-units=1 -Copt-level=0 -Clink-dead-code -Coverflow-checks=off -Zpanic_abort_tests -Cpanic=abort"
	set RUSTDOCFLAGS="-Cpanic=abort"

	set COVDIR ./target/debug/coverage
	set LLVM_PROFILE_FILE $COVDIR"/report.profraw"

	rm -rf $COVDIR

	cargo build --all-features

	cargo test --all-features

	grcov . -s . --binary-path ./target/debug/ -t html --branch --ignore-not-existing -o $COVDIR
	open $COVDIR"/index.html"
end

function new_ssl_cert
	openssl req -newkey rsa:2048 -new -nodes -x509 -days 365 -keyout key.rsa -out cert.pem
end

function common_ports
	awk '$2~/tcp$/' /usr/share/nmap/nmap-services | sort -r -k3 | head -n 1000 | tr -s ' ' | cut -d '/' -f1 | sed 's/\S*\s*\(\S*\).*/\1,/'
end




