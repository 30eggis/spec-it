import { NextResponse } from 'next/server';

// GET /api/posts - 게시글 목록
export async function GET() {
  const posts = [
    { id: 1, title: '첫 번째 글', content: '내용입니다.' },
    { id: 2, title: '두 번째 글', content: '또 다른 내용입니다.' },
  ];
  return NextResponse.json(posts);
}

// POST /api/posts - 게시글 작성
export async function POST(request: Request) {
  const body = await request.json();
  return NextResponse.json({ id: 3, ...body }, { status: 201 });
}

// PUT /api/posts - 게시글 수정
export async function PUT(request: Request) {
  const body = await request.json();
  return NextResponse.json({ ...body, updated: true });
}
